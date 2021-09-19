# variable "ec2-name" {
#   default = "tepe-ec2"
# }

variable "ec2-type" {
  default = "t2.micro"
}

# variable "ec2-ami" {
#   default = "ami-087c17d1fe0178315"
# }

variable "s3-bucket-name" {
  default = "tepe-s3-bucket"
}

variable "num_of_buckets" {
  default = "2"
}

variable "users" {
  default = ["john", "daniel", "davidof"]

}