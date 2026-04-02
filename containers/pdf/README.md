# PDF converters

podman pull xiaoyao9184/marker:master

podman run -d --name marker \
    xiaoyao9184/marker:master \
    -p 8501:8501 \
    -p 7860:7860
