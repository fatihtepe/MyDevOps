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