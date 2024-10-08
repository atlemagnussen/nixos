# K3S with nginx-ingress

## Install

default:
```sh
curl -sfL https://get.k3s.io | sh -
```

without traefik and lb
```sh
sudo curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable traefik,servicelb" sh -
```

kubectl
```sh
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config_k3s
```


## nginx

k apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.2/deploy/static/provider/baremetal/deploy.yaml

k apply -f k3s_loadbalancer.yaml

k create namespace test

k apply -f k3s.test.yaml --namespace test

kubectl -n ingress-nginx port-forward --address 0.0.0.0 svc/ingress-nginx-controller 443

sudo kubectl -n ingress-nginx port-forward --address 0.0.0.0 svc/ingress-nginx-controller-loadbalancer 443

## metallb

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.8/config/manifests/metallb-native.yaml


## try helm

helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace


## delete k3s
```sh
/usr/local/bin/k3s-uninstall.sh
```
