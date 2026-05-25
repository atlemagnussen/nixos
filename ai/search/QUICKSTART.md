# AI Product Search - Quick Start

## 🚀 Get Started in 3 Steps

### Step 1: Build the Application
```bash
chmod +x build.sh
./build.sh
```

### Step 2: Start the Services
```bash
docker compose up -d
# or
podman compose up -d
```

### Step 3: Download the AI Model
```bash
chmod +x download-model.sh
./download-model.sh
```

## 🎯 Access the Interface

Once services are running:
- **Web UI**: http://localhost:8000/static/index.html
- **API Documentation**: http://localhost:8000/docs
- **Health Check**: http://localhost:8000/health

## 📝 Example Searches

Try these queries in the web interface:

- "Find 27-inch 4K monitors under 500 EUR with USB-C and VESA"
- "Gaming laptops with RTX 4060 under 1500 EUR"  
- "Wireless headphones with noise cancellation under 200 USD"
- "Smart watches under 300 EUR with heart rate monitor"
- "Mechanical keyboards with hot-swap switches under 150 EUR"

## 📊 API Usage

### Search for Products
```bash
curl -X POST http://localhost:8000/search \
  -H "Content-Type: application/json" \
  -d '{
    "query": "Find 27-inch 4K monitors under 500 EUR with USB-C",
    "max_results": 20,
    "filters": {}
  }'
```

### Get Database Statistics
```bash
curl http://localhost:8000/stats
```

### Search Stored Products
```bash
curl "http://localhost:8000/products/search?query=monitor&limit=20"
```

## 🛠️ Troubleshooting

### Services won't start
```bash
# Check logs
docker compose logs

# Verify services are running
docker compose ps
```

### Can't connect to web interface
```bash
# Check if port 8000 is in use
lsof -i :8000

# Give services more time (first startup takes 30-60s)
docker compose logs search-agent
```

### Model download fails
```bash
# Check Ollama logs
docker compose logs ollama

# Manual model download
docker exec $(docker compose ps -q ollama) ollama pull qwen:instruct
```

## 📚 Full Documentation

See [IMPLEMENTATION.md](./IMPLEMENTATION.md) for:
- Architecture overview
- Component descriptions
- Database schema
- Advanced configuration
- Development guide

## 🖥️ System Requirements

- **CPU**: i7 or equivalent
- **RAM**: 16GB minimum, 32GB recommended
- **GPU**: Optional (Nvidia GPU for faster LLM inference)
- **Storage**: 50GB+ for Ollama models, 10GB+ for database
- **Network**: Internet access for SearXNG searches

## 📦 What's Included

- **FastAPI** web service with REST API
- **Ollama** with Qwen instruct model
- **SearXNG** for privacy-focused searches
- **SQLite** database for product storage
- **Modern web UI** with search and stats
- **Docker Compose** for easy deployment

## 🎨 Web UI Features

- Natural language product search
- Real-time price filtering
- Product specifications display
- Source tracking
- Search history and statistics
- Responsive design

## 🔄 How It Works

1. Enter a search query (e.g., "27-inch 4K monitors under 500 EUR")
2. **Qwen LLM** parses the query to extract criteria
3. **SearXNG** searches the web using multiple engines
4. **LLM** extracts product specs from results
5. Results are **filtered** based on your criteria
6. Products are **stored** in SQLite database
7. Results are **displayed** in the web interface

## 📈 Performance

- **Query parsing**: 2-5 seconds
- **Web search**: 3-10 seconds
- **Results filtering**: <1 second
- **Total time**: 5-15 seconds per search

## 🚀 Next Steps

- Add price tracking and alerts
- Implement product comparisons
- Add advanced filtering UI
- Export results (CSV, JSON)
- Machine learning ranking by value
- Multi-language support

## ❓ Questions?

Check [IMPLEMENTATION.md](./IMPLEMENTATION.md) for detailed documentation.
