# Hands-on Docker-08 : Docker Swarm Basic Operations

Purpose of this hands-on training is to give students the understanding to the Docker Swarm basic operations.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- Explain the what Docker Swarm cluster is.

- Set up a Docker Swarm cluster.

- Deploy an application as service on Docker Swarm.

- Do basic service operations within the Swarm cluster.

- Manage services within the Swarm.

## Outline

- Part 1 - Launch Docker Machine Instances and Connect with SSH

- Part 2 - Set up a Swarm Cluster with Manager and Worker Nodes

- Part 3 - Managing Docker Swarm Services

- Part 4 - Updating and Rolling Back in Docker Swarm

## Part 1 - Launch Docker Machine Instances and Connect with SSH

- Launch `five` Compose enabled Docker machines on Amazon Linux 2 with security group allowing SSH connections using the of [Clarusway Docker Swarm Cloudformation Template](./clarusway-docker-swarm-cfn-template.yml).

- Connect to your instances with SSH.

```bash
ssh -i .ssh/call-training.pem ec2-user@ec2-3-133-106-98.us-east-2.compute.amazonaws.com
```

## Part 2 - Set up a Swarm Cluster with Manager and Worker Nodes

- Prerequisites (Those prerequisites are satisfied within cloudformation template in Part 1)

  - Five EC2 instances on Amazon Linux 2 with `Docker` and `Docker Compose` installed.

  - Set these ingress rules on your EC2 security groups:

    - HTTP port 80 from 0.0.0.0\0

    - TCP port 2377 from 0.0.0.0\0

    - TCP port 8080 from 0.0.0.0\0

    - SSH port 22 from 0.0.0.0\0 (for increased security replace this with your own IP)

- Change the hostname  of the nodes, so we can discern the roles of each nodes. For example, you can name the nodes (instances) like master, worker-1 and worker-2.

```bash
sudo hostnamectl set-hostname <node-name-manager-or-worker>
```

- Check if the docker is active or not from the list of docker info (should be inactive at first).

```bash
docker info
```

- Get the internal IP addresses of docker machines,  you find out the Private IPs either on the EC2 dashboard, or from the command line by running the following command. Response should be something like `172.31.42.71`.

```bash
hostname -i
```

- Initialize `docker swarm` with Private IP and assign your first docker machine as manager:

```bash
docker swarm init
# or
docker swarm init --advertise-addr <Private IPs>
```

> Output

```bash
Swarm initialized: current node (6gpbx6r9vxwp37hjcdi41bhuc) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-4yfmqmk2xvly7mczdi21cuuhmem34v4ytrnvvkhzfajlptp4rk-dkfxxv4bq48rxomjjsjoxo5f1 172.31.9.149:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

- Check if the `docker swarm` is active or not and explain the swarm part of `docker info`.

```bash
docker info
```

> Output - Swarm part of `docker info`.

```text
 Swarm: active
  NodeID: kdo4jnfu5rzzxpqej7mnqnv3m
  Is Manager: true
  ClusterID: rbs71ftk1nnl91bo9k6cyotwa
  Managers: 1
  Nodes: 1
  Default Address Pool: 10.0.0.0/8
  SubnetSize: 24
  Data Path Port: 4789
  Orchestration:
   Task History Retention Limit: 5
  Raft:
   Snapshot Interval: 10000
   Number of Old Snapshots to Retain: 0
   Heartbeat Tick: 1
   Election Tick: 10
  Dispatcher:
   Heartbeat Period: 5 seconds
  CA Configuration:
   Expiry Duration: 3 months
   Force Rotate: 0
  Autolock Managers: false
  Root Rotation In Progress: false
  Node Address: 172.31.42.71
  Manager Addresses:
   172.31.42.71:2377
```

- Add 2 more nodes as manager to improve fault-tolerance. It is recommended to create clusters with an odd number of managers in Swarm, because a majority vote is needed between managers to agree on proposed management tasks according to `Raft Algorithm`. An odd—rather than even—number is strongly recommended to have a tie-breaking consensus. Having two managers is actually worse than having one.

- Get the manager token with `docker swarm join-token manager` command.

```bash
docker swarm join-token manager
```

> Output

```bash
To add a manager to this swarm, run the following command:

  docker swarm join --token SWMTKN-1-4yfmqmk2xvly7mczdi21cuuhmem34v4ytrnvvkhzfajlptp4rk-3zzm33eyq2gsj1sm0qnaygf8a 172.31.9.149:2377
```

- Add second and third Docker Machine instances as manager nodes, by connecting with SSH and running the given command above.

```bash
docker swarm join --token <manager_token> <manager_ip>:2377
```

- Add fourth and fifth Docker Machine instances as worker nodes. (Run `docker swarm join-token worker` command to get join-token for worker, if needed)

```bash
docker swarm join --token <worker_token> <manager_ip>:2377
```

- List the connected nodes in `Swarm` and explain difference between leader and other managers.

```bash
docker node ls
```

## Part 3 - Managing Docker Swarm Services

> Warning: If you have problem with `docker swarm` installation, you can use following link for lesson.
https://labs.play-with-docker.com

- Create a service for visualization. 

```bash
docker service create \
  --name=viz \
  --publish=8080:8080/tcp \
  --constraint=node.role==manager \
  --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  dockersamples/visualizer
```

- Learn which node is running `service viz` and check if the visualizer is running by entering `http://<ec2-host-name of this node>:8080` in a browser. (Nothing should be running)

```bash
docker service ps viz
```

- Start an `nginx service` with 5 replicas and show the replicas running on visualizer.

```bash
docker service create --name webserver --replicas=5 -p 80:80 -d nginx
```

- List services, explain what service is and the difference between container and service.

```bash
docker service ls
```

- Check if the `Nginx Web Server` is running by entering `http://<ec2-host-name-of-any-node>` in a browser.

- Display detailed information on service.

```bash
docker service inspect --pretty webserver
```

- List the tasks of service and explain what task is.

```bash
docker service ps webserver
```

- Fetch the logs of the service or a task.

```bash
docker service logs webserver
```

- Reboot a worker node and explain the last situation on visualizer app.

```bash
sudo reboot -f
```

- Scale up services and show the changes on visualizer app.

```bash
docker service scale webserver=10
```

- Scale down services and show the changes on visualizer app.

```bash
docker service scale webserver=3
```

- Remove service and show the changes on visualizer app.

```bash
docker service rm webserver
```

- Create service in `global mod`, show the changes on visualizer app and explain `global mod`.

```bash
docker service create --name glbserver --mode=global -p 80:80 nginx
```

- Remove a container and show that swarm creates a new task immediately.

```bash
docker container rm -f <containerid>
docker service ps glbserver
```

- Leave worker nodes from swarm and show the changes on visualizer app.

```bash
docker swarm leave
```

- Remove the `glbserver` service.

```bash
docker service rm glbserver
```

- Leave manager nodes from swarm

```bash
docker swarm leave --force
```

- Join manager and worker nodes again.

```bash
docker swarm join --token SWMTKN-1-1nkizkzhhqk4i7blzwww3znwhd0lqfsu3nlh9gl1pe7mco84up-5468yx80p9nfowv4eck0dqrvd 172.31.38.249:2377
```

## Part 4 - Updating and Rolling Back in Docker Swarm

- Create a new service of `clarusway/container-info:1.0` with 10 replicas.

```bash
docker service create --name clarusweb -p 80:80 --replicas=10 clarusway/container-info:1.0
```

- Explain `docker service update` command.

```bash
docker service update --help
```

- Update `clarusway/container-info:1.0` image with `clarusway/container-info:2.0` image and explain the changes.

```bash
docker service update --detach --update-delay 5s --update-parallelism 2 --image clarusway/container-info:2.0 clarusweb
watch docker service ps clarusweb
 ```

- Revert back to the earlier state of `clarusweb` service and monitor the changes.

```bash
docker service rollback --detach clarusweb
watch docker service ps clarusweb
 ```

 - Remove the service.

```bash
docker service rm clarusweb
```