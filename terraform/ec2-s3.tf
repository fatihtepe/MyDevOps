terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.59.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  # Configuration options
}

resource "aws_instance" "tf-ec2" {
  ami           = "ami-087c17d1fe0178315"
  instance_type = "t2.micro"
  tags = {
    "Name" = "created-by-tf"
  }
}

resource "aws_s3_bucket" "tf-s3" {
  bucket = "tf-test-bucketim"
  acl    = "private"
}


output "tf-example-public-ip" {
	value = aws_instance.tf-ec2.public_ip

}

output "tf-example-s3-meta" {
	value = aws_s3_bucket.tf-s3.region

}

