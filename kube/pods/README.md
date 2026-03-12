# Pods examples

kubectl get service <service-name> -o yaml > service-config.yaml

kubectl expose pod <pod-name> --port=<port> --target-port=<target-port> --name=<service-name>
