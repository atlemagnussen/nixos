podman pod stop ai-product-search
podman pod rm ai-product-search
git pull
podman build -t localhost/ai-search-agent:latest -f Containerfile .
podman play kube search-pod.yaml

