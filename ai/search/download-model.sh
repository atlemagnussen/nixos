#!/bin/bash
# Get the container ID and download the Qwen model

if command -v docker &> /dev/null; then
    DOCKER_CMD="docker"
elif command -v podman &> /dev/null; then
    DOCKER_CMD="podman"
else
    echo "Docker or Podman not found"
    exit 1
fi

echo "⏳ Pulling Qwen model into Ollama..."
echo ""

OLLAMA_CONTAINER=$($DOCKER_CMD compose ps -q ollama)

if [ -z "$OLLAMA_CONTAINER" ]; then
    echo "❌ Ollama container not running. Start services first:"
    echo "   $DOCKER_CMD compose up -d"
    exit 1
fi

$DOCKER_CMD exec $OLLAMA_CONTAINER ollama pull qwen:instruct

echo ""
echo "✅ Model downloaded successfully!"
echo "🎯 You can now use the search agent."
