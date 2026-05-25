# PDF converters

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


podman run -it \
    --device nvidia.com/gpu=all \
    -v /mnt/md1/Media/Books:/data \
    marker-gpu:latest \
    marker /data/LesserKey.pdf --output_dir /data/markdown


podman run -it --rm \
    --device /dev/nvidia0:/dev/nvidia0 \
    --device /dev/nvidiactl:/dev/nvidiactl \
    --device /dev/nvidia-uvm:/dev/nvidia-uvm \
    --device /dev/nvidia-uvm-tools:/dev/nvidia-uvm-tools \
    -v /usr/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu \
    -v /path/to/books:/data:Z \
    marker-server \
    /data/book.pdf --output_dir /data/output