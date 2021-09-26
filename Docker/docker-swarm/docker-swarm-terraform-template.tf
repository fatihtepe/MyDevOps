//This Terraform Template creates five Compose enabled Docker Machines on EC2 Instances
//which are ready for Docker Swarm operations, using the AMI (ami-087c17d1fe0178315).
//The AMI of Clarusway Compose enabled Docker Machine (docker-machine-with-compose-amazon-linux-2)
//is published on North Virginia Region.
//Docker Machines will run on Amazon Linux 2 with custom security group
//allowing SSH (22), HTTP (80) and TCP(2377, 8080) connections from anywhere.
//User needs to select appropriate key name when launching the template.

provider "aws" {
  region = "us-east-1"
  //  access_key = ""
  //  secret_key = ""
  //  If you have entered your credentials in AWS CLI before, you do not need to use these arguments.
}

resource "aws_instance" "tf-docker-machine" {
  ami           = "ami-087c17d1fe0178315"
  instance_type = "t2.micro"
  key_name      = "aws"
  //  Write your pem file name
  security_groups = ["docker-swarm-sec-gr"]
  count           = 5
  tags = {
    Name = "Docker-Swarm-Instance-${count.index + 1}"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              systemctl start docker
              systemctl enable docker
              usermod -a -G docker ec2-user
              # install docker-compose
              curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" \
              -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
	            EOF
}

resource "aws_security_group" "tf-docker-sec-gr" {
  name = "docker-swarm-sec-gr"
  tags = {
    Name = "docker-swarm-sec-group"
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

  ingress {
    from_port   = 2377
    protocol    = "tcp"
    to_port     = 2377
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    protocol    = "tcp"
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}