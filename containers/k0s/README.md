# k0s

https://docs.k0sproject.io/stable/install/

https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

k0s start
k0s status

k0s kubectl cluster-info

k0s kubectl get nodes

k0s kubectl get pods -A

# Install kubectl for convenience

https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management

copy cat `/var/lib/k0s/pki/admin.conf` to same or another machine `.kube/config`

```sh
sudo cp /var/lib/k0s/pki/admin.conf ~/.kube/config
```

kubectl create deploy hello-world --image=hello-world

kubectl create deploy nginx --image=nginx

kubectl get all
kubectl get pods 
kubectl expose deploy nginx --port 80 --type NodePort
kubectl get svc

kubectl delete svc nginx
kubectl delete deploy nginx

## NGINX ingress controller

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.2/deploy/static/provider/baremetal/deploy.yaml


## Create from file

k create -f kube-deploy.yaml 

Delete:
k delete -f kube-deploy.yaml 

## k3d

k3d cluster create atle-cluster

import image:
k3d image import test-net8-web -c atle-cluster

k3d cluster edit atle-cluster --port-add 30080-30085:30080-30085@loadbalancer





# docker hub

docker image tag test-net8-web atlmag/test-net8-web
docker push atlmag/test-net8-web:latest