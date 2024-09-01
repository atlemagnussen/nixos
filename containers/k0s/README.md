# k0s

https://docs.k0sproject.io/stable/install/

k0s start
k0s status

k0s kubectl cluster-info

k0s kubectl get nodes

k0s kubectl get pods -A


copy cat `/var/lib/k0s/pki/admin.conf` to another machine `.kube/config`

kubectl create deploy hello-world --image=hello-world

kubectl create deploy nginx --image=nginx

kubectl get all
kubectl get pods 
kubectl expose deploy nginx --port 80 --type NodePort
kubectl get svc

kubectl delete svc nginx
kubectl delete deploy nginx