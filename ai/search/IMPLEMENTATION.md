# AI Product Search - Implementation Guide

## Overview

This is a local AI-powered product search agent that finds deals on specific items (e.g., monitors, laptops, headphones).

## Architecture

```
┌─────────────┐
│   Web UI    │  (HTML/JS interface)
└──────┬──────┘
       │
┌──────▼──────────────────────────────┐
│   FastAPI Search Service            │
│  - /search (query processing)       │
│  - /products (database queries)     │
│  - /stats (analytics)               │
└──────┬──────────────────────────────┘
       │
       ├──────────────────┬──────────────────┬──────────────────┐
       │                  │                  │                  │
┌──────▼───────┐  ┌──────▼────────┐  ┌─────▼──────┐  ┌────────▼──────┐
│   Ollama     │  │   SearXNG     │  │  SQLite    │  │  Playwright   │
│   (LLM)      │  │   (Search)    │  │  (Storage) │  │  (Scraping)   │
│ Qwen Model   │  │               │  │            │  │               │
└──────────────┘  └───────────────┘  └────────────┘  └───────────────┘
```

## Components

### 1. **Ollama Service**
- Runs the Qwen instruct model
- Parses user queries to extract search criteria
- Extracts product specifications from search results
- Port: 11434

### 2. **SearXNG Service**
- Privacy-focused metasearch engine
- Aggregates results from multiple search engines
- Port: 8080

### 3. **FastAPI Search Agent**
- Main web service with REST API
- Orchestrates search flow
- Manages database operations
- Serves web interface
- Port: 8000

### 4. **SQLite Database**
- Stores product information
- Tracks search history
- Maintains comparisons
- Location: `/app/db/products.db`

## Quick Start

### Prerequisites
- Docker/Podman with GPU support (optional but recommended)
- 32GB RAM, i7+ CPU, Nvidia 1060 6GB (as configured)

### Option 1: Using Docker Compose

```bash
cd /data/code/nixos/ai/search

# Build the search agent image
docker build -t ai-search-agent:latest -f Containerfile .

# Start all services
docker compose up -d

# Check status
docker compose ps

# View logs
docker compose logs -f search-agent
```

### Option 2: Using Podman Pod

```bash
# Create the pod YAML (you have search-pod.yaml)
podman play kube search-pod.yaml

# Or for a simpler podman approach, adapt the docker-compose
```

### Access the Interface

- **Web UI**: http://localhost:8000/static/index.html
- **API Docs**: http://localhost:8000/docs
- **Health Check**: http://localhost:8000/health

## Download Models

First, pull the Qwen model into Ollama:

```bash
# Connect to ollama container
docker exec -it <ollama_container_id> bash

# Pull the qwen model
ollama pull qwen:instruct
```

Or if using podman:
```bash
podman exec -it <ollama_container_id> ollama pull qwen:instruct
```

## API Endpoints

### Search Products
```bash
curl -X POST http://localhost:8000/search \
  -H "Content-Type: application/json" \
  -d '{
    "query": "Find 27-inch 4K monitors under 500 EUR with USB-C and VESA",
    "max_results": 20,
    "filters": {}
  }'
```

### Get Stored Products
```bash
curl http://localhost:8000/products?limit=50&sort_by=price
```

### Search Database
```bash
curl "http://localhost:8000/products/search?query=monitor&limit=20"
```

### Get Statistics
```bash
curl http://localhost:8000/stats
```

## Search Query Examples

The system understands natural language product queries:

- "Find 27-inch 4K monitors under 500 EUR with USB-C and VESA"
- "Gaming laptops with RTX 4060 under 1500 EUR"
- "Wireless headphones with noise cancellation under 200 USD"
- "Smart watches with heart rate monitor under 300 EUR"
- "Mechanical keyboards with hot-swap switches under 150 EUR"

## Database Schema

### Products Table
```sql
- id: INTEGER (PRIMARY KEY)
- name: TEXT
- price: REAL
- currency: TEXT
- url: TEXT (UNIQUE)
- source: TEXT
- description: TEXT
- specs: JSON
- found_at: TIMESTAMP
- updated_at: TIMESTAMP
```

### Search History Table
```sql
- id: INTEGER (PRIMARY KEY)
- query: TEXT
- criteria: JSON
- result_count: INTEGER
- processing_time_ms: REAL
- executed_at: TIMESTAMP
```

### Comparisons Table
```sql
- id: INTEGER (PRIMARY KEY)
- comparison_name: TEXT
- products: JSON
- notes: TEXT
- created_at: TIMESTAMP
```

## Configuration

### Environment Variables (in docker-compose.yaml)
```
OLLAMA_BASE_URL=http://ollama:11434
SEARXNG_BASE_URL=http://searxng:8080
DB_PATH=/app/db/products.db
MODEL_NAME=qwen:instruct
```

### GPU Support
The setup includes GPU support for Ollama. Ensure:
1. Nvidia Docker runtime is installed
2. `nvidia-smi` shows your GPU
3. Docker compose reserves GPU resources

## Performance Notes

With your hardware (i7, 32GB RAM, Nvidia 1060 6GB):
- **Search query parsing**: ~2-5 seconds
- **Web search**: ~3-10 seconds (depends on internet speed)
- **Total search time**: ~5-15 seconds per query
- **Database operations**: <100ms

## Troubleshooting

### Ollama Connection Failed
```bash
# Check if ollama is running
docker compose ps ollama

# Check logs
docker compose logs ollama

# Verify port 11434 is accessible
curl http://localhost:11434/api/tags
```

### SearXNG Not Working
```bash
# Check status
curl http://localhost:8080/health

# View logs
docker compose logs searxng
```

### No GPU Detected
```bash
# Verify NVIDIA Docker runtime
docker run --rm --runtime=nvidia nvidia/cuda:11.8.0-base-ubuntu22.04 nvidia-smi

# Check docker daemon config
cat /etc/docker/daemon.json
```

## Next Steps

1. **Web Scraping**: Add Playwright-based deep scraping for detailed product info
2. **Price Comparison**: Implement price history tracking and alerts
3. **ML Ranking**: Use ML model to rank products by value (price/specs ratio)
4. **Notifications**: Add email/webhook alerts for products matching criteria
5. **Advanced Filtering**: UI for advanced filters (brand, specs, ratings, etc.)
6. **Export**: Add CSV/JSON export functionality

## Development

### Running Locally Without Docker

```bash
# Install dependencies
pip install -r app/requirements.txt

# Set environment variables
export OLLAMA_BASE_URL=http://localhost:11434
export SEARXNG_BASE_URL=http://localhost:8080
export DB_PATH=./db/products.db

# Run the service
cd app
python -m uvicorn main:app --reload
```

### Testing the Search Agent

```python
import asyncio
from app.services.search_agent import SearchAgent
from app.services.db_manager import DatabaseManager

async def test():
    db = DatabaseManager("./db/products.db")
    db.init_db()
    
    agent = SearchAgent(
        ollama_url="http://localhost:11434",
        searxng_url="http://localhost:8080",
        model_name="qwen:instruct",
        db_manager=db
    )
    
    results = await agent.search(
        "Find 27-inch 4K monitors under 500 EUR with USB-C"
    )
    
    for product in results:
        print(f"{product['name']} - {product['price']} {product['currency']}")

asyncio.run(test())
```

## License

This project is open source. Modify and distribute freely.
