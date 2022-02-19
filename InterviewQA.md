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
