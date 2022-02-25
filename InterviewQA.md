## [What is a Kubernetes Ephemeral Container?](https://devopslearners.com/what-is-a-kubernetes-ephemeral-container-aa8ab658755d)

When it comes to container security, distroless or minimal base images reduce the attack surface. But the common concern in using a distroless or minimal image is that,
How do I take an exec session to troubleshoot if something goes wrong in the application? `Because these images won’t even have a shell or any utilities required for troubleshooting`.

An ephemeral container is a concept of adding a container in an exiting pod for debugging purposes.

Let’s say you have a pod running on a minimal base image with just the application binaries and dependencies. Something went wrong, and you need to debug.

Since it is a stripped-down minimal base image without a shell, you cannot perform a “kubectl exec” command.

The following command will add the debug-image container to the running frontend pod and take an exec session for debugging.
```
kubectl debug -it pods/frontend — image=debug-image
```
## [How To Reduce Docker Image Size: 6 Optimization Methods](https://devopslearners.com/how-to-reduce-docker-image-size-6-optimization-methods-cbbdab1196a7)

##

- it is best to have small-sized images to **reduce the image transfer and deploy time.**

![](./img/docker1.png)


****Method 1: Use Minimal Base Images****

- Your first focus should be on choosing the right base image with a minimal OS footprint.

Also, most of the distributions now have their minimal base images.

> Note: You cannot directly use the publicly available base images in project environments. You need to get approval from the enterprise security team to use the base image. In some organizations, the security team itself publishes base images every month after testing & security scanning. Those images would be available in the common organization docker private repository.
>
- You can further reduce the base image size using [distroless images](https://github.com/GoogleContainerTools/distroless). It is a stripped-down version of the operating system. Distroless base images are available for java, nodejs, python, Rust, etc.

****Method 2: Use Docker Multistage Builds****

- In multistage build, we get similar advantages as the builder pattern. We use **intermediate images**
 (build stages) to compile code, install dependencies, and package files in this approach. The idea behind this is to **eliminate unwanted layers**
 in the image.

```markdown
FROM node:16 as build

WORKDIR /app
COPY package.json index.js env ./
RUN npm install

FROM gcr.io/distroless/nodejs

COPY --from=build /app /
EXPOSE 3000
CMD ["index.js"]
```

***Method 3: Minimize the Number of Layers***

Docker images work in the following way — each `RUN, COPY, FROM` Dockerfile instructions add a new layer & each layer adds to the build execution time & increases the storage requirements of the image.

![](./img/docker2.png)

The Docker daemon has an in-built capability to display the total execution time that a Dockerfile is taking. To enable this feature, take the following steps -  `export DOCKER_BUILDKIT=1`

`time docker build -t fatihtepe/optimize:3.0 --no-cache -f Dockerfile4 .`

### **Method 4: Understanding Caching**

Often, the same image has to be rebuilt again & again with slight modifications in code.

Docker helps in such cases by storing the cache of each layer of a build, hoping that it might be useful in the future.

Due to this concept, it’s recommended to add the lines which are used for installing dependencies & packages earlier inside the Dockerfile — **before the COPY commands.**

The reason behind this is that docker would be able to cache the image with the required dependencies, and this cache can then be used in the following builds when code gets modified.

For example, let’s take a look at the following two Dockerfiles.

Dockerfile5

```
FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y
COPY .
```

Dockerfile6

```
FROM ubuntu:latest
COPY . .
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y

```

Docker would be able to **use the cache functionality better** with Dockerfile6 than Dockerfile5 due to the better placement of the COPY command.

### **Method 5: Use Dockerignore**

As a rule, only the necessary files need to be copied over the docker image.

Docker can ignore the files present in the working directory if configured in the `.dockerignore` file.

This feature should be kept in mind while optimizing the docker image.

### **Method 6: Keep Application Data Elsewhere**

Storing application data in the image will unnecessarily increase the size of the images.

It’s highly recommended to use the volume feature of the container runtimes to keep the image separate from the data.

Docker containers support the implementation of CI/CD in development. Image size and build efficiency are important factors when overseeing and working with the [microservice architecture](https://phoenixnap.com/kb/introduction-to-microservices-architecture). This is why you should try to keep your Docker images small, by following the valuable advice outlined in this article.

## [Kubernetes — Objects (Resources) Overview](https://medium.com/devops-mojo/kubernetes-objects-resources-overview-introduction-understanding-kubernetes-objects-24d7b47bb018)
## [Kubernetes Architecture -In-Depth](https://bikramat.medium.com/kubernetes-architecture-in-depth-b5b909b10d77)


Kubernetes Control Plane Components
* `Kube API server`: Kubernetes API server is the central management entity that receives all requests for modifications of pods, services, replication controller, deployments, etc. `This is the only component that communicates with the etcd cluster.`

- `ETCD`: ETCD is a simple, distributed key-value storage that is used to store the Kubernetes cluster data (such as a number of pods, their state, namespace, etc).

- `Kube Controller Manager`: Controllers take care of actually running the cluster, and the Kubernetes controller-manager contains several controller functions in one. `Replication controller, Node Controller, Endpoints controller, ervice Account and Token controllers`

- `Kube Scheduler`: The scheduler is responsible to schedule pods in different nodes based on resource utilization. It reads the service’s operational requirements and schedules it on the best fit node. `For example, if the application needs 1GB of memory and 2 CPU cores, then the pods for that application will be scheduled on a node with at least those resources.`

Kubernetes Worker Components

- `Kubelet`: It is a Kubernetes agent that runs on each node in the cluster that communicates with the control plane.The kubelet takes a set of PodSpecs that are provided by the API server and ensures that the containers described in those PodSpecs are running and healthy. This component also reports about the state and health of the containers.

- `Kube Proxy`: Kube-proxy is a network proxy that runs on each node in your cluster. It also maintains network rules, allows network communication between services and pods, and is responsible for routing network traffic.

- `Container Runtime Interface`: A container runtime, also known as a container engine, is a software component that is responsible for running containers. The kubelet communicates with the container engine through the standard Container Runtime Interface and pulls the docker image from the docker hub.

How does Kubernetes work?

![k8s](./img/k8s.png)

- A user writes a YAML file for pod specification and submits it to the API server, the API server will check for the authentication of that user, whether the user is authorized to perform the requested actions or not.

- Once the user validation is passed, the API server will store all the data related to pods and their specifications in the ETCD cluster.

- The schedule continuously watches the new request from the API server and once it gets the request from the API server, the scheduler finds the appropriate healthy worker nodes that match the requirement.

- The kubelet further communicates with the container engine through the standard Container Runtime Interface and pulls the docker image from the Docker hub and deploys the pods.

- Controllers watch and monitor the deployed pods and in case of any failure, it reports to the API server.


[Bind Mount vs Docker Managed Volume](https://blog.devgenius.io/docker-data-volume-af83671e25af)

![dockerVolume](./img/dockerVolume.png)
In specific use, docker provides two types of volumes: `bind mount` and `docker managed volume`.
- bind mount

bind mount is to mount an existing directory or file on the host to the container.
```
docker run -d -p 80:80 -v ~/htdocs:/usr/local/apache2/htdocts:ro httpd
```
/usr/local/apache2/htdocs is where the httpd server stores static files. since this director already exists in the container, the original data will be hidden and replaced by data in ~/htdocs , which is persistent since it is located on the host.

- docker managed volume

`The biggest difference between docker-managed volume and bind mount is that there is no need to specify the mount source, just specify the mount point. Or take the httpd container as an example:
`
```
docker run -d -p 80:80 -v /usr/local/apache2/htdocs httpd
```
We do this by telling docker that we need a data volume and mount it to /usr/local/apache2/htdocs. So where exactly is this data volume?

This answer can be found in the container’s configuration information, execute the command: docker inspect .

```
docker inspect dafbfa86b404
......
"Mounts": [
{
  "Name": "fe43eaa90cfc3773ef535ec9e0a094d0ab0477ceb74ddebd57d3620ab50e85b1",
  "Source": "/var/lib/docker/volumes/fe43eaa90cfc3773ef535ec9e0a094d0ab0477ceb74ddebd57d3620ab50e85b1/_data",
  "Destination": "/usr/local/apache2/htdocs",
  "Driver": "local",
  "Mode": "",
  "RW": true,
  "Propagation": ""
}],
```
docker generates a random directory in `/var/lib/docker/volumes` as mount source.

## [Basic Helm Concepts](https://faun.pub/helm-command-cheat-sheet-by-m-sharma-488706ecf131)

Helm is a Kubernetes package manager for deploying helm charts (collections of pre-configured Kubernetes application resources).

Helm commands work with several Helm-related concepts. Understanding them makes the syntax easier to follow.

- The most important `Helm concept` is a `chart`. A chart is a set of Kubernetes yaml manifests packaged together for easy manipulation. Helm charts make it possible to deploy a containerized application using a single command.
- Charts are grouped in online collections called repositories. Each repository has a name and URL, making the charts easy to locate, download, and install.
- `Helm Charts` Hub is a place to find, install and publish Kubernetes packages
- A release is a single instance of a chart deployed in a Kubernetes cluster.

## [Jenkins Pipeline: Declarative vs. Scripted](https://medium.com/globant/jenkins-pipeline-declarative-vs-scripted-21f8688ee16a)

- Jenkins pipeline comes with two types: Declarative and Scripted.

- A CI/CD pipeline is an automated way of getting source code from version control systems to the users via different stations such as Version Control System, Code Inspection, Test Cases Execution, Build, Artifact Creation, Artifact Repository, and Deployment on the servers.

- Pipelines are also referred to as a “Deployment-as-a-Code”.

- Jenkins is based on DSL, which is Domain Specific Language. A domain-specific language is a language that is developed to solve specific domain problems.

![jenkins](./img/jenkins.png)

Conclusion:

Both declarative and scripted pipelines are a great way of building deployment pipelines but nowadays, the declarative pipeline is a more preferred way to write a pipeline. You can leverage the benefit of scripted pipeline in a declarative pipeline using Script step but not vice versa.


## [Git Clone vs Fork in GITHUB](https://chedyhammami.medium.com/git-clone-vs-fork-in-github-610f158d61e3)

Let’s say you want to contribute to an open-source project;

First, you Fork the project’s GitHub repository, now that you have it on your Github account, You Clone it using the commit “git clone”, now It’s on your local machine.

Now you can apply any changes or edits you which to on the local copy on your machine, once you finished your edits you commit them and push them to your Github repo.

Your Github repo now is synced with the changes made to your local machine’s copy, it’s time to merge those changes with the original “open-source project repo”.

Changes made to the forked repository can be merged with the original repository via pull request. A Pull request knocks on the repository owner and tells them “Please check my changes and merge them if you like it”

If they accept, the original repo will have your changes in it, and Congrats you just contributed to an Open-source project


## [Manage IAM permissions](https://aws.amazon.com/iam/features/manage-permissions/)

## [What is a CI/CD pipeline?](https://www.redhat.com/en/topics/devops/what-cicd-pipeline)

## [What is Jira used for?](https://www.atlassian.com/software/jira/guides/use-cases/what-is-jira-used-for)

