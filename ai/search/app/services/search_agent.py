"""
AI Search Agent - Core search logic
"""
import asyncio
import json
import logging
import time
import re
from datetime import datetime
from typing import List, Optional, Dict, Any
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin
from playwright.async_api import async_playwright

logger = logging.getLogger(__name__)

class SearchAgent:
    def __init__(self, ollama_url: str, searxng_url: str, model_name: str, db_manager):
        self.ollama_url = ollama_url
        self.searxng_url = searxng_url
        self.model_name = model_name
        self.db_manager = db_manager
        self.last_processing_time = 0.0
        self.ollama_urls = self._build_url_candidates(
            ollama_url,
            ["http://localhost:11434", "http://127.0.0.1:11434", "http://ollama:11434"]
        )
        self.searxng_urls = self._build_url_candidates(
            searxng_url,
            ["http://localhost:8080", "http://127.0.0.1:8080", "http://searxng:8080", "http://localhost:8091"]
        )

    def _build_url_candidates(self, primary: str, fallbacks: List[str]) -> List[str]:
        """Build a de-duplicated ordered list of base URLs to try."""
        ordered = [primary] + fallbacks
        seen = set()
        normalized = []
        for url in ordered:
            clean = (url or "").strip().rstrip("/")
            if not clean or clean in seen:
                continue
            seen.add(clean)
            normalized.append(clean)
        return normalized

    def _ollama_generate(self, prompt: str, timeout: int = 60) -> Optional[str]:
        """Try configured Ollama endpoints until one responds successfully."""
        payload = {
            "model": self.model_name,
            "prompt": prompt,
            "stream": False,
            "temperature": 0.3
        }

        for base_url in self.ollama_urls:
            try:
                response = requests.post(
                    f"{base_url}/api/generate",
                    json=payload,
                    timeout=timeout
                )
                if response.status_code == 200:
                    result = response.json()
                    return result.get("response", "")
                logger.warning("Ollama returned status %s from %s", response.status_code, base_url)
            except Exception as e:
                logger.warning("Ollama unavailable at %s: %s", base_url, str(e))

        return None

    def _price_sort_key(self, product: Dict[str, Any]) -> float:
        """Return a stable numeric key for price sorting.

        Missing or invalid prices are pushed to the end.
        """
        value = product.get("price")
        if value is None:
            return float("inf")
        if isinstance(value, (int, float)):
            return float(value)
        if isinstance(value, str):
            cleaned = value.strip().replace(" ", "")
            cleaned = re.sub(r"[^\d.,]", "", cleaned).replace(",", ".")
            try:
                return float(cleaned)
            except ValueError:
                return float("inf")
        return float("inf")
        
    async def search(
        self,
        query: str,
        max_results: int = 20,
        filters: Optional[Dict[str, Any]] = None
    ) -> List[Dict]:
        """Execute a product search"""
        start_time = time.time()
        
        try:
            # Step 1: Parse query using LLM to extract search criteria
            logger.info(f"Parsing query: {query}")
            search_criteria = await self._parse_query_with_llm(query)
            search_criteria = self._normalize_criteria(search_criteria)
            logger.info(f"Extracted criteria: {search_criteria}")
            
            # Step 2: Perform web search using SearXNG
            logger.info("Searching with SearXNG...")
            search_results = await self._search_with_searxng(query, max_results)

            if not search_results:
                fallback_query = search_criteria.get("product_type") or query
                logger.info(f"Primary search returned no results, trying fallback query: {fallback_query}")
                search_results = await self._search_with_searxng(fallback_query, max_results)
            
            # Step 3: Extract and parse product information
            logger.info("Extracting product information...")
            products = await self._extract_products(search_results, search_criteria)
            
            # Step 4: Filter results based on criteria
            logger.info("Filtering results...")
            filtered_products = self._filter_products(products, search_criteria)

            # If filtering is too strict, return extracted products sorted by price relevance.
            if not filtered_products and products:
                logger.info("Filtering removed all products, returning unfiltered candidates")
                filtered_products = sorted(products, key=self._price_sort_key)
            
            # Step 5: Store in database
            logger.info("Storing results in database...")
            for product in filtered_products:
                product_id = self.db_manager.add_product(product)
                product["id"] = product_id
                product["found_at"] = datetime.utcnow().isoformat()
            
            self.last_processing_time = time.time() - start_time
            logger.info(f"Search completed in {self.last_processing_time:.2f}s")
            
            return filtered_products[:max_results]
            
        except Exception as e:
            logger.error(f"Search failed: {str(e)}")
            raise

    async def _parse_query_with_llm(self, query: str) -> Dict[str, Any]:
        """Use Ollama to parse the search query and extract criteria"""
        prompt = f"""Extract product search criteria from this query:
        
Query: {query}

Return JSON with:
- product_type: (what kind of product)
- specifications: (list of required specs)
- budget_min: (minimum price or null)
- budget_max: (maximum price or null)
- currency: (currency if mentioned, e.g., EUR, USD)
- must_haves: (critical features)
- nice_to_haves: (optional features)

JSON response only, no other text:"""

        try:
            text = self._ollama_generate(prompt, timeout=60)
            if text:
                # Try to extract JSON from response
                json_match = re.search(r'\{[\s\S]*\}', text)
                if json_match:
                    criteria = json.loads(json_match.group())
                    return criteria
        except Exception as e:
            logger.error(f"LLM query parsing failed: {str(e)}")
        
        # Fallback: return basic criteria
        return {
            "product_type": query,
            "specifications": [],
            "budget_min": None,
            "budget_max": None,
            "currency": "EUR",
            "must_haves": [],
            "nice_to_haves": []
        }

    def _normalize_criteria(self, criteria: Dict[str, Any]) -> Dict[str, Any]:
        """Normalize LLM criteria shape to predictable types."""
        normalized = dict(criteria or {})

        for key in ("must_haves", "nice_to_haves", "specifications"):
            value = normalized.get(key, [])
            if isinstance(value, str):
                value = [v.strip() for v in re.split(r",|;|\n", value) if v.strip()]
            elif not isinstance(value, list):
                value = []
            normalized[key] = [str(v).strip() for v in value if str(v).strip()]

        for key in ("budget_min", "budget_max"):
            value = normalized.get(key)
            if isinstance(value, str):
                value = value.strip().replace(" ", "")
                value = re.sub(r"[^\d.,]", "", value)
                value = value.replace(",", ".")
            try:
                normalized[key] = float(value) if value not in (None, "") else None
            except (TypeError, ValueError):
                normalized[key] = None

        if not normalized.get("product_type"):
            normalized["product_type"] = ""

        if not normalized.get("currency"):
            normalized["currency"] = "EUR"

        return normalized

    async def _search_with_searxng(self, query: str, max_results: int) -> List[Dict]:
        """Search using SearXNG"""
        params = {
            "q": query,
            "format": "json",
            "pageno": 1,
            "results_on_new_tab": True,
        }

        for base_url in self.searxng_urls:
            try:
                response = requests.get(
                    f"{base_url}/search",
                    params=params,
                    timeout=30,
                    headers={"Accept": "application/json"}
                )

                if response.status_code != 200:
                    logger.warning("SearXNG returned status %s from %s", response.status_code, base_url)
                    continue

                data = response.json()
                results = data.get("results", [])
                if results:
                    return results[:max_results]

                logger.warning("SearXNG returned empty results from %s", base_url)
            except Exception as e:
                logger.warning("SearXNG unavailable at %s: %s", base_url, str(e))
        
        return []

    async def _extract_products(
        self,
        search_results: List[Dict],
        criteria: Dict
    ) -> List[Dict]:
        """Extract product information from search results"""
        products = []
        
        for result in search_results:
            try:
                product = {
                    "name": result.get("title", ""),
                    "url": result.get("url", ""),
                    "source": result.get("engine", "unknown"),
                    "description": result.get("content", ""),
                    "price": None,
                    "currency": criteria.get("currency", "EUR"),
                    "specs": await self._extract_specs_with_llm(
                        result.get("title", "") + " " + result.get("content", ""),
                        criteria
                    )
                }
                
                # Try to extract price
                price = self._extract_price(result.get("content", ""))
                if price:
                    product["price"] = price
                
                if product["name"]:
                    products.append(product)
                    
            except Exception as e:
                logger.error(f"Failed to extract product: {str(e)}")
        
        return products

    def _extract_price(self, text: str) -> Optional[float]:
        """Extract price from text"""
        # Look for price patterns like €500 or EUR 500 or $500
        patterns = [
            r'€\s*(\d+(?:[.,]\d{2})?)',  # €500 or € 500
            r'EUR\s*(\d+(?:[.,]\d{2})?)',  # EUR 500
            r'\$\s*(\d+(?:[.,]\d{2})?)',  # $500
            r'(\d+(?:[.,]\d{2})?)\s*EUR',  # 500 EUR
            r'(\d+(?:[.,]\d{2})?)\s*€',   # 500 €
        ]
        
        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                price_str = match.group(1).replace(',', '.')
                try:
                    return float(price_str)
                except ValueError:
                    pass
        
        return None

    async def _extract_specs_with_llm(
        self,
        text: str,
        criteria: Dict
    ) -> Dict[str, Any]:
        """Use LLM to extract relevant specifications"""
        prompt = f"""Extract specifications from this product description:

Text: {text[:500]}

Based on criteria:
Must haves: {criteria.get('must_haves', [])}
Nice to haves: {criteria.get('nice_to_haves', [])}

Return JSON with matched specifications:"""

        try:
            response_text = self._ollama_generate(prompt, timeout=30)
            if response_text:
                json_match = re.search(r'\{[\s\S]*\}', response_text)
                if json_match:
                    specs = json.loads(json_match.group())
                    return specs
        except Exception as e:
            logger.error(f"Specs extraction failed: {str(e)}")
        
        return {}

    def _filter_products(
        self,
        products: List[Dict],
        criteria: Dict
    ) -> List[Dict]:
        """Filter products based on search criteria"""
        filtered = []
        
        budget_min = criteria.get("budget_min")
        budget_max = criteria.get("budget_max")
        must_haves = criteria.get("must_haves", [])

        # Keep requirements concise; LLM can return long phrases that are too strict as hard filters.
        must_haves = [m for m in must_haves if 1 <= len(m) <= 24]
        
        for product in products:
            # Filter by price
            if product.get("price"):
                if budget_min and product["price"] < budget_min:
                    continue
                if budget_max and product["price"] > budget_max:
                    continue
            
            # Filter by must-haves
            if must_haves:
                product_text = (
                    product.get("name", "") + " " +
                    product.get("description", "") + " " +
                    json.dumps(product.get("specs", {}))
                ).lower()

                match_count = sum(1 for have in must_haves if have.lower() in product_text)
                min_required = max(1, len(must_haves) // 2)
                if match_count < min_required:
                    continue
            
            filtered.append(product)
        
        # Sort by price (ascending)
        filtered.sort(key=self._price_sort_key)
        
        return filtered
