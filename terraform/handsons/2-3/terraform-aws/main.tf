terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.59.0"
    }
  }

  backend "s3" {
    bucket         = "tf-state-remote-bucket-tepe"
    key            = "env/dev/tf-remote-backend.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-s3-app-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
  # Configuration options
}

resource "aws_instance" "tf-ec2" {
  ami           = data.aws_ami.tf-ami.id
  instance_type = var.ec2-type
  tags = {
    Name = "${local.instance-name}-my-ami instance"
  }
}

resource "aws_s3_bucket" "tf-s3" {
  # bucket = "${var.s3-bucket-name}-${count.index}"
  acl = "private"
  # count = var.num_of_buckets
  # count = var.num_of_buckets ==2 ? var.num_of_buckets:1
  for_each = toset(var.users)
  bucket   = "s3-buket-${each.value}"
}


resource "aws_iam_user" "names" {
  for_each = toset(var.users)
  name     = each.value
}


data "aws_ami" "tf-ami" {
  most_recent = true
  owners      = ["self"]


  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


locals {
  instance-name = "tepe-local-name"
}
