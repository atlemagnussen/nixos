# 🎯 AI Product Search - Quick Reference Card

## 🚀 Start in 3 Commands

```bash
cd /data/code/nixos/ai/search
./build.sh                      # Build Docker image
docker compose up -d            # Start services (wait 30s)
./download-model.sh             # Download Qwen model (5-10 min)
```

## 🌐 Access Points

| Component | URL | Purpose |
|-----------|-----|---------|
| Web UI | http://localhost:8000/static/index.html | Search interface |
| API Docs | http://localhost:8000/docs | Interactive API docs |
| Health | http://localhost:8000/health | Service status |

## 🔍 Example Searches

```
"Find 27-inch 4K monitors under 500 EUR with USB-C"
"Gaming laptops with RTX 4060 under 1500 EUR"
"Wireless headphones with noise cancellation"
"Smart watches with heart rate under 300 EUR"
```

## 📡 API Quick Reference

### Search for Products
```bash
curl -X POST http://localhost:8000/search \
  -H "Content-Type: application/json" \
  -d '{"query": "monitors 4K", "max_results": 20}'
```

### Get Statistics  
```bash
curl http://localhost:8000/stats
```

### Database Search
```bash
curl "http://localhost:8000/products/search?query=monitor"
```

## 🛠️ Service Management

```bash
# Start
docker compose up -d

# Status
docker compose ps
docker compose logs -f search-agent

# Stop
docker compose down

# Restart
docker compose restart

# Clean
docker compose down -v
```

## 📝 CLI Usage

```bash
# Search via command line
python cli.py search "27-inch 4K monitors under 500 EUR"

# Get stats
python cli.py stats
```

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| Services won't start | `docker compose logs` then `docker compose down -v && docker compose up -d` |
| No results | Wait 30-60s, check `docker compose logs searxng` |
| Model download stuck | `docker exec $(docker compose ps -q ollama) ollama pull qwen:instruct` |
| Port already in use | Change ports in docker-compose.yaml or stop conflicting service |
| Database errors | `rm db/products.db && docker compose restart` |

## 📊 What's Running

| Service | Port | Purpose | Memory |
|---------|------|---------|--------|
| Ollama | 11434 | LLM inference (GPU) | 2-4GB |
| SearXNG | 8080 | Web search aggregator | 200-500MB |
| FastAPI | 8000 | Web service & API | 200-300MB |
| SQLite | N/A | Database | <100MB |

## 📁 Key Files

```
app/main.py              ← Web service & API endpoints
app/services/search_agent.py ← Search logic with LLM
app/services/db_manager.py   ← Database operations
web/index.html           ← Web interface
docker-compose.yaml      ← Service orchestration
```

## 🎓 How It Works (3 Steps)

1. **Parse Query** (LLM)
   - "Find 27-inch 4K monitors under 500 EUR"
   - Extracts: size, resolution, price, currency, specs

2. **Search Web** (SearXNG)
   - Multi-engine search (Google, Bing, etc.)
   - Returns relevant links

3. **Filter & Store** (Agent)
   - LLM extracts specs from results
   - Filters by criteria
   - Stores in SQLite
   - Returns to user

## 🔐 Privacy Notes

- ✅ Local LLM (no API calls to OpenAI/Claude)
- ✅ Local database (no cloud storage)
- ✅ SearXNG is privacy-focused
- ✅ All processing on your machine

## 📚 Documentation

- **QUICKSTART.md** - Getting started
- **IMPLEMENTATION.md** - Technical details
- **SETUP_COMPLETE.md** - Full summary

## 🚀 Advanced Usage

### NixOS Deployment
```bash
# Add to /etc/nixos/configuration.nix:
imports = [ /data/code/nixos/ai/search/ai-search.nix ];

# Rebuild:
sudo nixos-rebuild switch

# Start:
sudo systemctl start ai-search-pod
```

### Custom Model
```bash
# In docker-compose.yaml, change:
MODEL_NAME=mistral:instruct  # or qwen:7b, neural-chat, etc.

# Then download:
docker exec $(docker compose ps -q ollama) ollama pull mistral:instruct
```

### Database Backup
```bash
cp db/products.db db/products.db.backup
```

## 📞 Support

1. Check logs: `docker compose logs [service]`
2. Read IMPLEMENTATION.md for detailed docs
3. Check API docs at http://localhost:8000/docs
4. Review example searches in web interface

## ✨ Key Stats

- **Query Parse Time**: 2-5 seconds
- **Web Search Time**: 3-10 seconds
- **Total Response**: 5-15 seconds
- **Database Queries**: <100ms
- **Storage Used**: ~50GB (models) + 10GB (DB)

---

**Start here**: `./build.sh && docker compose up -d && ./download-model.sh`

Then visit: **http://localhost:8000/static/index.html**
