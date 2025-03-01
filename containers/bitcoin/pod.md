# Run as pod 

podman pod create --name bitcoin-lightning

podman run -dt --pod bitcoin-lightning ubuntu

podman generate kube bitcoin-lightning