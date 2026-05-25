"""
AI Product Search Agent - FastAPI Web Service
"""
import os
import json
import logging
from typing import Optional, List
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import RedirectResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
import sqlite3
from datetime import datetime

from services.search_agent import SearchAgent
from services.db_manager import DatabaseManager

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize FastAPI
app = FastAPI(
    title="AI Product Search",
    description="Local AI agent for finding product deals",
    version="0.1.0"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Configuration
OLLAMA_BASE_URL = os.getenv("OLLAMA_BASE_URL", "http://localhost:11434")
SEARXNG_BASE_URL = os.getenv("SEARXNG_BASE_URL", "http://localhost:8080")
DB_PATH = os.getenv("DB_PATH", "/app/db/products.db")
MODEL_NAME = os.getenv("MODEL_NAME", "qwen:instruct")

# Initialize services
db_manager = DatabaseManager(DB_PATH)
search_agent = SearchAgent(
    ollama_url=OLLAMA_BASE_URL,
    searxng_url=SEARXNG_BASE_URL,
    model_name=MODEL_NAME,
    db_manager=db_manager
)

# Ensure database is initialized
db_manager.init_db()

# Pydantic models
class SearchQuery(BaseModel):
    query: str
    max_results: int = 20
    filters: Optional[dict] = None

class ProductResult(BaseModel):
    id: int
    name: str
    price: float
    currency: str
    url: str
    source: str
    specs: dict
    found_at: str

class SearchResponse(BaseModel):
    query: str
    results: List[ProductResult]
    processing_time: float
    model_used: str

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "ollama_url": OLLAMA_BASE_URL,
        "searxng_url": SEARXNG_BASE_URL,
        "model": MODEL_NAME,
        "db_path": DB_PATH
    }

@app.post("/search", response_model=SearchResponse)
async def search(query_data: SearchQuery):
    """
    Execute a product search query
    
    Example: "Find 27-inch 4K monitors under 500 EUR with USB-C and VESA"
    """
    try:
        logger.info(f"Executing search: {query_data.query}")
        
        results = await search_agent.search(
            query=query_data.query,
            max_results=query_data.max_results,
            filters=query_data.filters
        )
        
        return SearchResponse(
            query=query_data.query,
            results=results,
            processing_time=search_agent.last_processing_time,
            model_used=MODEL_NAME
        )
    except Exception as e:
        logger.error(f"Search failed: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/products")
async def get_products(
    limit: int = 50,
    offset: int = 0,
    sort_by: str = "price"
):
    """Get stored products from database"""
    try:
        products = db_manager.get_products(limit=limit, offset=offset, sort_by=sort_by)
        return {
            "total": db_manager.count_products(),
            "limit": limit,
            "offset": offset,
            "products": products
        }
    except Exception as e:
        logger.error(f"Failed to fetch products: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/products/search")
async def search_products_db(
    query: str,
    limit: int = 20
):
    """Search products stored in database"""
    try:
        products = db_manager.search_products(query, limit=limit)
        return {"results": products}
    except Exception as e:
        logger.error(f"Database search failed: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/stats")
async def get_stats():
    """Get search statistics"""
    return {
        "total_products": db_manager.count_products(),
        "unique_sources": db_manager.count_sources(),
        "price_stats": db_manager.get_price_stats()
    }

@app.post("/products/clear")
async def clear_products():
    """Clear all products from database (use with caution)"""
    try:
        db_manager.clear_products()
        return {"message": "Products cleared"}
    except Exception as e:
        logger.error(f"Failed to clear products: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

# Serve static files
if os.path.exists("/app/web"):
    app.mount("/static", StaticFiles(directory="/app/web"), name="static")

@app.get("/index.html", include_in_schema=False)
async def index_html_redirect():
    """Compatibility route for direct index URL access"""
    return RedirectResponse(url="/static/index.html", status_code=307)

@app.get("/")
async def root():
    """Root endpoint - serves web interface"""
    return {
        "message": "AI Product Search Service",
        "docs": "/docs",
        "web_ui": "/static/index.html"
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
