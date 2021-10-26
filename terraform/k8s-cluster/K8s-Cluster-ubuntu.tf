provider "aws" {
  region = "us-east-1"
  //profile = ""
}

data "aws_ami" "tf-ami" {
  # owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {
  name = "us-east-1"
}

resource "aws_iam_role" "aws_access" {
  name = "awsrole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "my_inline_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          "Effect" : "Allow",
          "Action" : "ec2-instance-connect:SendSSHPublicKey",
          "Resource" : "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/*",
          "Condition" : {
            "StringEquals" : {
              "ec2:osuser" : "ubuntu"
            }
          }
        },
        {
          "Effect" : "Allow",
          "Action" : "ec2:DescribeInstances",
          "Resource" : "*"
        }
      ]
    })
  }
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess", "arn:aws:iam::aws:policy/AmazonEC2FullAccess", "arn:aws:iam::aws:policy/IAMFullAccess", "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess"]

}

resource "aws_iam_instance_profile" "ec2-profile" {
  name = "k8s-cluster-profile"
  role = aws_iam_role.aws_access.name
}

resource "aws_security_group" "tf-k8s-sec-gr-manager" {
  name = "tf-k8s-sec-gr-manager"
  tags = {
    Name = "k8s-manager-sec-group"
  }
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "tf-k8s-sec-gr-worker" {
  name = "tf-k8s-sec-gr-worker"
  tags = {
    Name = "k8s-worker-sec-group"
  }
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "sg-rule-manager1" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.tf-k8s-sec-gr-manager.id
  source_security_group_id = aws_security_group.tf-k8s-sec-gr-manager.id
}

resource "aws_security_group_rule" "sg-rule-manager2" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.tf-k8s-sec-gr-worker.id
  source_security_group_id = aws_security_group.tf-k8s-sec-gr-manager.id
}

resource "aws_security_group_rule" "sg-rule-worker1" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.tf-k8s-sec-gr-manager.id
  source_security_group_id = aws_security_group.tf-k8s-sec-gr-worker.id
}

resource "aws_security_group_rule" "sg-rule-worker2" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.tf-k8s-sec-gr-worker.id
  source_security_group_id = aws_security_group.tf-k8s-sec-gr-worker.id
}

resource "aws_instance" "tf-k8s-manager" {
  ami           = data.aws_ami.tf-ami.id
  instance_type = "t3.medium"
  key_name      = "aws"
  //  Write your pem file name
  security_groups      = ["tf-k8s-sec-gr-manager"]
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
  tags = {
    Name = "Kubernetes-Manager"
  }
  user_data = <<-OFD
    #!/bin/bash
    apt-get update -y
    apt-get upgrade -y
    hostnamectl set-hostname kube-manager
    chmod 777 /etc/sysctl.conf
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -p
    chmod 644 /etc/sysctl.conf
    apt install -y docker.io
    systemctl start docker
    mkdir /etc/docker
    cat <<EOF | tee /etc/docker/daemon.json
    {
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "100m"
    },
    "storage-driver": "overlay2"
    }
    EOF
    systemctl enable docker
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    usermod -aG docker ubuntu
    newgrp docker
    apt install -y apt-transport-https
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
    apt update
    apt install -y kubelet kubeadm kubectl
    systemctl start kubelet
    systemctl enable kubelet
    kubeadm init --pod-network-cidr=172.16.0.0/16 --ignore-preflight-errors=All
    mkdir -p /home/ubuntu/.kube
    cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
    chown ubuntu:ubuntu /home/ubuntu/.kube/config
    su - ubuntu -c 'kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml'
    alias k='kubectl' >> /home/ubuntu/.bash_profile
    OFD
}

resource "aws_instance" "tf-k8s-worker" {
  ami           = data.aws_ami.tf-ami.id
  instance_type = "t3.medium"
  key_name      = "aws"
  //  Write your pem file name
  security_groups      = ["tf-k8s-sec-gr-worker"]
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
  count                = 1
  tags = {
    Name = "Kubernetes-Worker-${count.index + 1}"
  }
  depends_on = [aws_instance.tf-k8s-manager]
  user_data  = <<-OFD
    #!/bin/bash
    apt-get update -y
    apt-get upgrade -y
    hostnamectl set-hostname kube-worker${count.index + 1}
    chmod 777 /etc/sysctl.conf
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -p
    chmod 644 /etc/sysctl.conf
    apt install -y docker.io
    systemctl start docker
    cat <<EOF | tee /etc/docker/daemon.json
    {
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "100m"
    },
    "storage-driver": "overlay2"
    }
    EOF
    systemctl enable docker
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    usermod -aG docker ubuntu
    newgrp docker
    apt install -y apt-transport-https
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
    apt update
    apt install -y kubelet kubeadm kubectl
    systemctl start kubelet
    systemctl enable kubelet
    apt install -y python3-pip
    pip3 install ec2instanceconnectcli
    apt install -y mssh
    until [[ $(mssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -r ${data.aws_region.current.name} ubuntu@${aws_instance.tf-k8s-manager.id} kubectl get no | awk 'NR == 2 {print $2}') == Ready ]]; do echo "master node is not ready"; sleep 3; done;
    kubeadm join ${aws_instance.tf-k8s-manager.private_ip}:6443 --token $(mssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -r ${data.aws_region.current.name} ubuntu@${aws_instance.tf-k8s-manager.id} kubeadm token list | awk 'NR == 2 {print $1}') --discovery-token-ca-cert-hash sha256:$(mssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -r ${data.aws_region.current.name} ubuntu@${aws_instance.tf-k8s-manager.id} openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //') --ignore-preflight-errors=All
    OFD
}

output "k8s-manager-ip" {
  value = aws_instance.tf-k8s-manager.public_ip
}

//output "k8s-worker-ip" {
//  value = aws_instance.tf-k8s-worker[${count.index + 1}].public_ip
//}

