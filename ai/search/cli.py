#!/usr/bin/env python3
"""
AI Product Search - Command Line Interface
Quick test/usage without web browser
"""

import subprocess
import json
import time
import sys

def run_search(query: str, max_results: int = 20):
    """Execute a search via the API"""
    print(f"\n🔍 Searching: {query}\n")
    
    curl_cmd = [
        "curl", "-X", "POST", "http://localhost:8000/search",
        "-H", "Content-Type: application/json",
        "-d", json.dumps({
            "query": query,
            "max_results": max_results,
            "filters": {}
        })
    ]
    
    try:
        result = subprocess.run(curl_cmd, capture_output=True, text=True, timeout=60)
        
        if result.returncode == 0:
            data = json.loads(result.stdout)
            
            print(f"✅ Found {len(data['results'])} products in {data['processing_time']:.2f}s\n")
            
            for i, product in enumerate(data['results'][:5], 1):
                print(f"{i}. {product['name']}")
                if product['price']:
                    print(f"   💰 {product['price']} {product['currency']}")
                print(f"   🔗 {product['source']}")
                print(f"   📌 {product['url']}\n")
        else:
            print(f"❌ Error: {result.stderr}")
            
    except subprocess.TimeoutExpired:
        print("❌ Request timed out")
    except json.JSONDecodeError:
        print("❌ Invalid response from server")
    except Exception as e:
        print(f"❌ Error: {str(e)}")

def get_stats():
    """Get database statistics"""
    print("\n📊 Database Statistics\n")
    
    curl_cmd = ["curl", "http://localhost:8000/stats"]
    
    try:
        result = subprocess.run(curl_cmd, capture_output=True, text=True)
        
        if result.returncode == 0:
            data = json.loads(result.stdout)
            
            print(f"Total Products: {data['total_products']}")
            print(f"Unique Sources: {data['unique_sources']}")
            
            stats = data['price_stats']
            if stats.get('min'):
                print(f"Min Price: {stats['min']}")
                print(f"Max Price: {stats['max']}")
                print(f"Avg Price: {stats['average']:.2f}")
        else:
            print(f"❌ Error: {result.stderr}")
            
    except Exception as e:
        print(f"❌ Error: {str(e)}")

def main():
    print("=" * 60)
    print("🚀 AI Product Search - CLI")
    print("=" * 60)
    
    # Example searches
    example_queries = [
        "Find 27-inch 4K monitors under 500 EUR with USB-C and VESA",
        "Gaming laptops with RTX 4060 under 1500 EUR",
        "Wireless headphones with noise cancellation under 200 USD",
    ]
    
    print("\n📝 Available searches:")
    for i, query in enumerate(example_queries, 1):
        print(f"{i}. {query}")
    
    print("\nUsage:")
    print("  python cli.py search '<your query>'")
    print("  python cli.py stats")
    
    if len(sys.argv) < 2:
        print("\n💡 Example:")
        print("  python cli.py search 'Find 27-inch 4K monitors under 500 EUR'")
        print("\nMaking example search...")
        run_search(example_queries[0])
        get_stats()
    elif sys.argv[1] == "search" and len(sys.argv) > 2:
        run_search(" ".join(sys.argv[2:]))
        get_stats()
    elif sys.argv[1] == "stats":
        get_stats()
    else:
        print("Usage: python cli.py [search '<query>' | stats]")

if __name__ == "__main__":
    main()
