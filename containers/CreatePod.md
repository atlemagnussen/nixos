# Create a pod with network

## Add base pod
podman pod create \
  --name DbOpsPod \
  --dns 1.1.1.1 \
  --dns 8.8.8.8

## append image
podman run -d --pod DbOpsPod --name DbOpsPod-app localhost/digilean/dbopsapp:latest 

## export pod file
podman generate kube DbOpsPod

