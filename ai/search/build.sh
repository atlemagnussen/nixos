#!/bin/bash
# Quick start script for AI Product Search

set -e

echo "🚀 Starting AI Product Search Setup..."

# Check if Docker/Podman is available
if command -v docker &> /dev/null; then
    DOCKER_CMD="docker"
elif command -v podman &> /dev/null; then
    DOCKER_CMD="podman"
else
    echo "❌ Docker or Podman not found. Please install one of them."
    exit 1
fi

echo "✅ Using: $DOCKER_CMD"

# Change to script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo ""
echo "📦 Building search agent image..."
$DOCKER_CMD build -t localhost/ai-search-agent:latest -t ai-search-agent:latest -f Containerfile .

echo ""
echo "✅ Build complete!"
echo ""
echo "🎯 To start the services, run:"
echo "   $DOCKER_CMD play kube search-pod.yaml"
echo ""
echo "⏳ Wait a moment for services to start, then:"
echo "   - Web UI: http://localhost:8090/static/index.html"
echo "   - API Docs: http://localhost:8090/docs"
echo "   - SearXNG: http://localhost:8091"
echo ""
echo "📝 First time setup:"
echo "   1. Give services 30 seconds to start"
echo "   2. Download Qwen model:"
echo "      $DOCKER_CMD exec -it \$(${DOCKER_CMD} ps --format '{{.ID}} {{.Names}}' | grep ollama | awk '{print \$1}') ollama pull qwen:instruct"
echo ""
echo "🔍 To search, visit: http://localhost:8090/static/index.html"
