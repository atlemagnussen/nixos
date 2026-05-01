# PDF converters

podman build -f Containerfile -t atlmag/marker-api:latest .

podman run --rm \
  --device nvidia.com/gpu=all \
  -p 8000:8000 \
  -v /tmp:/data \
  marker-api:latest

podman run --rm -it --pull=never --device nvidia.com/gpu=all atlmag/marker-api:latest bash
  
podman run -d --name marker-api --replace --pull=never \
  --network=host \
  --device nvidia.com/gpu=all \
  -v /tmp:/data \
  localhost/atlmag/marker-api:latest --port 8008 --host 0.0.0.0


curl -s -X POST http://127.0.0.1:8008/marker \
  -H "Content-Type: application/json" \
  -d '{"filepath":"/data/A2-6-n.pdf","output_format":"markdown"}' | tee response.json


jq -r '.markdown' response.json > index.md

jq -r '.images | to_entries[] | "\(.key)\t\(.value)"' response.json \
  | while IFS=$'\t' read -r name b64; do
      printf '%s' "$b64" | base64 -d > "$name"
    done


## Crap


podman pull xiaoyao9184/marker:master

podman run -d --name marker \
    xiaoyao9184/marker:master \
    -p 8501:8501 \
    -p 7860:7860


https://github.com/datalab-to/marker

sudo apt install python3-venv
sudo apt install python3-torch


mkdir maker-venv
cd maker-venv
python3 -m venv venv
source venv/bin/activate
pip install marker-pdf



marker_single ./pdf/1.pdf --output_format html --output_dir ./html


Additional stuff:
sudo apt install -y \
    libgl1-mesa-glx \
    libmagic1 \
    poppler-utils \
    tesseract-ocr \
    libtesseract-dev \
    ghostscrip