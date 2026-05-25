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
$DOCKER_CMD build -t ai-search-agent:latest -f Containerfile .

echo ""
echo "✅ Build complete!"
echo ""
echo "🎯 To start the services, run:"
echo "   $DOCKER_CMD compose up -d"
echo ""
echo "⏳ Wait a moment for services to start, then:"
echo "   - Web UI: http://localhost:8000/static/index.html"
echo "   - API Docs: http://localhost:8000/docs"
echo ""
echo "📝 First time setup:"
echo "   1. Give services 30 seconds to start"
echo "   2. Download Qwen model:"
echo "      $DOCKER_CMD exec \$(${DOCKER_CMD} compose ps -q ollama) ollama pull qwen:instruct"
echo ""
echo "🔍 To search, visit: http://localhost:8000/static/index.html"
