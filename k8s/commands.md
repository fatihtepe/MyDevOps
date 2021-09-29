```
alias k=kubectl
```
```
k get pods -A
k get pods -A -o wide
k get pods -A -o yaml
k get pods -A -o json
```

```
k get pods -A -o json | jq -r ".items[].spec.containers[].name"  #only names
```
```
k explain pod
k explain deployment
```
```
k run firstpod --image=nginx --restart=Never  # create a simple pod
```
```
 k describe pods firstpod
```
```
 k logs firstpod
```
```
k logs -f firstpod
```
```
k exec firstpod -- hostname
```
```
 k exec firstpod -- ls
```
```
k exec firstpod -it firstpod -- /bin/sh
```
```
 k delete pods firstpod
```

```
 k apply -f pod1.yaml
```

```
k run secondpod --image=nginx --port=80 --labels="app=frontend" --restart=Never
```

```
k edit pods firstpod    #pod/firstpod edited
```

```
k apply -f podlife1.yaml
```
```
k get pods -w  # watch live
```

```
k delete -f podlife1.yaml
```

```
 minikube start
```
```
minikube delete
```
```

```
k apply -f podmulticontainer.yaml
```

k logs -f multicontainer -c sidecarcontainer
```

```
k exec -it multicontainer -c webcontainer -- /bin/sh
```
```
 k exec -it multicontainer -c sidecarcontainer -- /bin/sh
```
```
k port-forward pod/multicontainer 8080:80
```

```
 k apply -f podinitcontainer.yaml
```

```
k logs -f initcontainerpod -c initcontainer
```

```
 k get namespaces
```

```
k get pods --namespace kube-system
```
```
k get pods --all-namespaces
```
```
╰─ k get pods --all-namespaces -A
```
```
 k create namespace app1
```

```
 k get namespaces
```

```
─ k apply -f podnamespace.yaml
```

```
k get pods -n development
```

```
─ k exec -it namespacepod -n development -- /bin/sh
```
```
k config set-context --current --namespace=development
```
```
 k get pods
```
```
k config set-context --current --namespace=default
```
```
k create deployment firstdeployment --image=nginx:latest --replica=2
```
```
kubectl delete --all pods
```

