- A `container runtime` is software that executes containers and manages container images on a node. [***](https://kubernetes.io/blog/2018/05/24/kubernetes-containerd-integration-goes-ga/)

- "Does switching to containerd mean I can't use Docker Engine anymore?" We hear this question a lot, the short answer is NO. (Since containerd is being used by both Kubelet and Docker Engine, this means users who choose the containerd integration will not just get new Kubernetes features, performance, and stability improvements, they will also have the option of keeping Docker Engine around for other use cases.)

`Kubernetes is removing support for Docker as a container runtime.` Kubernetes does not actually handle the process of running containers on a machine. Instead, it relies on another piece of software called a container runtime.[***](https://acloudguru.com/blog/engineering/kubernetes-is-deprecating-docker-what-you-need-to-know)

`containerD` An industry-standard container runtime with an emphasis on simplicity, robustness and portability [***](https://containerd.io/)

`kubeadm` is a tool built to provide kubeadm init and kubeadm join as best-practice "fast paths" for creating Kubernetes clusters.[***](https://kubernetes.io/docs/reference/setup-tools/kubeadm/)

`kubectl` controls the Kubernetes cluster manager [***](https://kubernetes.io/docs/reference/kubectl/kubectl/)

The `kubelet` is the primary "node agent" that runs on each node. It can register the node with the apiserver using one of: the hostname; a flag to override the hostname; or specific logic for a cloud provider.[***](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/)