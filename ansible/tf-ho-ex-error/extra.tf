//This Terraform Template creates 4 Ansible Machines on EC2 Instances
//Ansible Machines will run on Amazon Linux 2 and Ubuntu 20.04 with custom security group
//allowing SSH (22) and HTTP (80) connections from anywhere.
//User needs to select appropriate key name when launching the instance.

provider "aws" {
  region = "us-east-1"
#   access_key = "AKIA33KVYFLTLW7ERL73"
#   secret_key = "rVsBc+n2F1exgX4IRxuzZzUYb4aSFETohOfMwwwn"
  //  If you have entered your credentials in AWS CLI before, you do not need to use these arguments.
}

resource "aws_instance" "ansible-webserver" {
  ami             = "ami-02e136e904f3da870"
  instance_type   = "t2.micro"
  key_name        = "aws"
  //  Write your pem file name
  security_groups = ["ansible-sec-group"]
  count = 2
  tags = {
    Name = "node-webserver"
    role = "webserver"
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              hostnamectl set-hostname "node- ${count.index + 1}"
              bash
              EOF
}

resource "aws_instance" "ansible-db-server" {
  ami             = "ami-02e136e904f3da870"
  instance_type   = "t2.micro"
  key_name        = "aws"
  //  Write your pem file name
  security_groups = ["ansible-sec-group"]
  count = 2
  tags = {
    Name = "node-dbserver"
    role = "database"
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              hostnamectl set-hostname "node- ${count.index + 1}"
              bash
              EOF
}

resource "aws_instance" "ansible-control-server" {
  ami             = "ami-02e136e904f3da870"
  instance_type   = "t2.micro"
  key_name        = "aws"
  //  Write your pem file name
  security_groups = ["ansible-sec-group"]
  tags = {
    Name = "control-node"
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install ansible2
              hostnamectl set-hostname "control-leader-server"
              bash
              echo "[defaults]
              host_key_checking = False
              interpreter_python=auto_silent" > /etc/ansible/ansible.cfg
              echo "[webservers]
              node1 ansible_host=${aws_instance.ansible-webserver[0].private_ip} ansible_user=ec2-user
              [dbservers]
              node2 ansible_host=${aws_instance.ansible-db-server[0].private_ip} ansible_user=ec2-user
              [all:vars]
              ansible_ssh_private_key_file=/home/ec2-user/.ssh/aws.pem"  > /etc/ansible/hosts
              EOF
}


  resource "aws_security_group" "ansible-sec-gr" {
    name = "ansible-sec-group"
    tags = {
      Name = "ansible-sec-group"
    }
    ingress {
      from_port   = 80
      protocol    = "tcp"
      to_port     = 80
      cidr_blocks = ["0.0.0.0/0"]
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
output "control-public-ip" {
  value = aws_instance.ansible-control-server.public_ip
}
output "web-public-ips" {
  value = aws_instance.ansible-webserver.*.public_ip
}

output "db-public-ips" {
  value = aws_instance.ansible-db-server.*.public_ip
}

output "control-private-ip" {
  value = aws_instance.ansible-control-server.private_ip
}
output "db-private-ips" {
  value = aws_instance.ansible-db-server.*.private_ip
}

output "web-private-ips" {
  value = aws_instance.ansible-webserver.*.private_ip
}