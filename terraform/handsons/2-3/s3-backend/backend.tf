provider "aws" {
  region = "us-east-1"

}

resource "aws_s3_bucket" "tf-remote-state" {
  bucket        = "tf-state-remote-bucket-tepe"
  force_destroy = true # for the sake of practice! you should use prevent_destroy
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "tf-remote-state_lock" {
  hash_key = "LockID"
  name     = "tf-s3-app-lock"
  attribute {
    name = "LockID"
    type = "S"
  }
  billing_mode = "PAY_PER_REQUEST"

}

