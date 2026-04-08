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