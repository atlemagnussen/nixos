# Marker PDF to Markdown API Container

This container runs the Marker PDF conversion tool with a FastAPI server for GPU-accelerated document processing.

## Prerequisites

- podman installed
- NVIDIA GPU drivers installed on host
- nvidia-podman or podman with GPU support configured

## Build

```bash
cd /path/to/containers/pdf
podman build -t marker-api:latest .
```

## Run

### With GPU Support (NVIDIA 1060)

```bash
podman run --rm \
  --device nvidia.com/gpu=all \
  -p 8000:8000 \
  -v /path/to/your/pdfs:/data \
  marker-api:latest
```

### Alternative: Using nvidia-docker wrapper

If you have nvidia-docker installed:
```bash
nvidia-podman run --rm \
  -p 8000:8000 \
  -v /path/to/your/pdfs:/data \
  marker-api:latest
```

### Without GPU (CPU only - slower)

```bash
podman run --rm \
  -p 8000:8000 \
  -v /path/to/your/pdfs:/data \
  -e TORCH_DEVICE=cpu \
  marker-api:latest
```

## Test the API

Once running, access the API at:
- **API docs (Swagger UI)**: http://localhost:8000/docs
- **Alternative docs (ReDoc)**: http://localhost:8000/redoc

### Example API Call

```python
import requests
import json

# Single file conversion
response = requests.post(
    "http://localhost:8000/marker",
    json={
        "filepath": "/data/sample.pdf",
        "output_format": "markdown"  # or "json", "html", "chunks"
    }
)

result = response.json()
print(result)
```

Or with curl:
```bash
curl -X POST "http://localhost:8000/marker" \
  -H "Content-Type: application/json" \
  -d '{
    "filepath": "/data/sample.pdf",
    "output_format": "markdown"
  }'
```

## Interactive Testing

To bash into the container:

```bash
podman run --rm -it \
  --device nvidia.com/gpu=all \
  -v /path/to/your/pdfs:/data \
  -p 8000:8000 \
  marker-api:latest \
  /bin/bash
```

Inside the container, test marker:

```bash
# Check GPU is available
python -c "import torch; print(torch.cuda.is_available())"

# Convert a single PDF
marker_single /data/sample.pdf

# Or start the API server manually
marker_server --port 8000 --host 0.0.0.0
```

## Troubleshooting

### GPU not detected

Check if nvidia-podman is properly configured:
```bash
podman run --device nvidia.com/gpu=all nvidia/cuda:12.1.0-runtime-ubuntu22.04 nvidia-smi
```

### Out of memory errors

Reduce worker count:
```bash
podman run --rm \
  --device nvidia.com/gpu=all \
  -p 8000:8000 \
  -v /path/to/your/pdfs:/data \
  -e WORKERS=2 \
  marker-api:latest
```

### High accuracy mode (slower, more accurate)

Add LLM support by passing configuration:
```bash
# Requires Gemini API key
podman run --rm \
  --device nvidia.com/gpu=all \
  -p 8000:8000 \
  -v /path/to/your/pdfs:/data \
  -e GEMINI_API_KEY=your_key_here \
  marker-api:latest
```

## Output Formats

- **markdown**: Clean markdown with embedded images and LaTeX
- **json**: Hierarchical JSON structure with block types
- **html**: HTML representation
- **chunks**: Flattened JSON for RAG applications

## Performance Notes

- NVIDIA 1060: ~1-2 pages/second (depending on document complexity)
- GPU memory usage: ~3-5GB VRAM average per worker
- CPU can be used as fallback but will be 5-10x slower

## References

- [Marker GitHub](https://github.com/datalab-to/marker)
- [Marker API Docs](https://github.com/datalab-to/marker#api-server)
