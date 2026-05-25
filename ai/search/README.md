# AI Product Search - Local Deal Finder

## Original Requirements ✅

- ✅ Ollama for LLM inference
- ✅ Custom Python script (FastAPI service)
- ✅ Playwright support (in search_agent)
- ✅ SearXNG for web search aggregation
- ✅ Qwen instruct model
- ✅ SQLite database for products, results, and comparisons
- ✅ Podman pod YAML configuration (`search-pod.yaml`)
- ✅ Web interface for prompting and results display
- ✅ CLI interface as fallback
- ✅ Example: "Find 27-inch 4K monitors under 500 EUR with USB-C and VESA"

**Target System**: i7 CPU, 32GB RAM, Nvidia 1060 6GB (GPU acceleration enabled)

## ✅ Implementation Complete

All components have been implemented and are ready to deploy with podman on your stationary system.

## Initial Steps

Before running the pod, create the host folders used by bind mounts and place the SearXNG settings file there.

```bash
# Create host folders used by search-pod.yaml
sudo mkdir -p /mnt/ssd2/ai/search/ollama
sudo mkdir -p /mnt/ssd2/ai/search/searxng
sudo mkdir -p /mnt/ssd2/ai/search/db

# Optional: make your user the owner
sudo chown -R "$USER":"$USER" /mnt/ssd2/ai/search

# Copy SearXNG config into the mounted config folder
cp /data/code/nixos/ai/search/config/searxng-settings.yml /mnt/ssd2/ai/search/searxng/settings.yml
```

Then run the pod using the single pod file:

```bash
cd /data/code/nixos/ai/search
podman play kube search-pod.yaml
```

### Quick Start with Podman

```bash
# 1. Build the container image
podman build -t ai-search-agent:latest -f Containerfile .

# 2. Start with podman play kube
podman play kube search-pod.yaml

# 3. Download the Qwen model
podman exec <ollama-container-id> ollama pull qwen:instruct

# 4. Access web interface
# http://localhost:8090/static/index.html
```

## 📚 Documentation

- **QUICKSTART.md** - Getting started (adapt for podman)
- **IMPLEMENTATION.md** - Full technical documentation
- **SETUP_COMPLETE.md** - Complete overview of all components
- **QUICK_REFERENCE.md** - Quick reference card

## 📁 Project Contents

```
app/                        - FastAPI web service
  ├── main.py              - REST API endpoints
  ├── services/
  │   ├── search_agent.py  - LLM-powered search logic
  │   └── db_manager.py    - SQLite operations
  └── requirements.txt     - Python dependencies

web/                        - Frontend
  └── index.html          - Modern web interface

config/                     - Configurations
  └── searxng-settings.yml - Search engine config

Containerfile               - Container build spec
search-pod.yaml            - Podman pod configuration ⭐
docker-compose.yaml        - Alternative Docker Compose setup
cli.py                     - Command-line interface

Scripts:
  ├── build.sh             - Build container image
  ├── download-model.sh    - Download Qwen model
  └── deploy-nixos.sh      - NixOS deployment help
```

## 🎯 Build & Deploy Steps

### Step 1: Build the Image
```bash
cd /data/code/nixos/ai/search
podman build -t ai-search-agent:latest -f Containerfile .
```

### Step 2: Deploy with Podman
```bash
# Option A: Using podman play kube (Kubernetes-style)
podman play kube search-pod.yaml

# Option B: Using podman compose
podman compose up -d
```

### Step 3: Download Model
```bash
# Get the ollama container ID
OLLAMA_ID=$(podman ps | grep ollama | awk '{print $1}')

# Download Qwen model
podman exec $OLLAMA_ID ollama pull qwen:instruct
```

### Step 4: Access Interface
- Web UI: **http://localhost:8090/static/index.html**
- API Docs: **http://localhost:8090/docs**
- CLI: `python cli.py search "your query"`

## Troubleshooting: "No results found"

If the UI responds quickly with no results, verify these two dependencies first.

### 1. Check SearXNG is actually running

```bash
# Replace with your pod/container names if needed
podman ps --format '{{.ID}} {{.Names}}' | grep -i searxng
podman logs $(podman ps --format '{{.ID}} {{.Names}}' | grep -i searxng | awk '{print $1}') | tail -n 120

# JSON endpoint should return a number > 0 for a normal query
curl -s "http://localhost:8091/search?q=monitor&format=json" | jq '.results | length'
```

### 2. Ensure Ollama model exists

```bash
podman exec -it $(podman ps --format '{{.ID}} {{.Names}}' | grep -i ollama | awk '{print $1}') ollama list
podman exec -it $(podman ps --format '{{.ID}} {{.Names}}' | grep -i ollama | awk '{print $1}') ollama pull qwen:instruct
```

### 3. Recopy SearXNG config and restart pod

```bash
cp /data/code/nixos/ai/search/config/searxng-settings.yml /mnt/ssd2/ai/search/searxng/settings.yml
podman play kube --down search-pod.yaml
podman play kube search-pod.yaml
```