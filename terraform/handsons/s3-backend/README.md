# Hands-on Terraform-03 : Terraform Remote Backend and Modules.

Purpose of the this hands-on training is to give students the knowledge of remote backend and modules in Terraform.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- Create a remote backend and use modules.

### Terraform Remote State (Remote backend)

- A `backend` in Terraform determines how tfstate file is loaded/stored and how an operation such as apply is executed. This abstraction enables non-local file state storage, remote execution, etc. By default, Terraform uses the "local" backend, which is the normal behavior of Terraform you're used to.

- Go to the AWS console and attach DynamoDBFullAaccess policy to the existing role.

![state-locking](state-locking.png)

- Create a new folder named  `s3-backend` and a file named `backend.tf`. 

```txt
    s3-backend
       └── backend.tf
    terraform-aws
       ├── oliver.tfvars
       ├── main.tf
       └── variables.tf

```

- Go to the `s3-backend` folder and create a file name `backend.tf`. Add the followings.

```bash
cd .. && mkdir s3-backend && cd s3-backend && touch backend.tf
```

```bash
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "tf-remote-state" {
  bucket = "tf-remote-s3-bucket-oliver-changehere"
  
  force_destroy = true

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
  name = "tf-s3-app-lock"
  attribute {
    name = "LockID"
    type = "S"
  }
billing_mode = "PAY_PER_REQUEST"
}
```

- Run the commands belov.

```bash
terraform init   

terraform apply
```

- We have created a S3 bucket and a Dynamodb table. Now associate S3 bucket with the Dynamodb table. 

- Go to the `main.tf` file make the changes.

```bash
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.56.0"
    }
  }
  backend "s3" {
    bucket = "tf-remote-s3-bucket-oliver-changehere"
    key = "env/dev/tf-remote-backend.tfstate"
    region = "us-east-1"
    dynamodb_table = "tf-s3-app-lock"
    encrypt = true
  }
}
```

- Go to the `terraform-aws` directoy and run the commands below. First try to terraform apply command.

```bash
- cd ../terraform-aws
```

```bash
terraform apply  

terraform init  

terraform apply
```

- Because of using S3 bucket for backend, run `terraform init` again. It will ask you to copy the existing tfstate file to s3. yes.

- Go to the `main.tf` file add the followings.
```bash
output "s3-arn-1" {
  value = aws_s3_bucket.tf-s3["fredo"].arn
  }
```
```bash
terraform apply
```

- Go to the AWS console and check the S3 bucket, tfstate file. tfstate file is copied from local to S3 backend.

- Go to the `main.tf` file make the changes (add another output).

```bash
  output "s3-arn-2" {
      value = aws_s3_bucket.tf-s3["santino"].arn
  }
```

- Open a new terminal. Write `terraform apply` in the both terminal. Try to run the command in both terminals at the same time.

- We do not get an error in the terminal that we run `terraform apply` command for the first time, but we get an error in the terminal we run later.

- Now you can try to run the same command with the second terminal. Check the Dynamo DB table and items.

- Destroy all resources.

```bash
terraform destroy   

terraform destroy
```

### Terraform Modules

-Create folders name `terraform-modules`, `modules`, `dev`, `prod` directories in the home directory and files as below.

```bash
cd && mkdir terraform-modules && cd terraform-modules && mkdir dev modules prod && cd dev && touch dev-vpc.tf && cd ../modules && touch main.tf outputs.tf variables.tf && cd ../prod && touch prod-vpc.tf && cd ../modules
```

```txt
 terraform-modules
   ├── dev
   │   └── dev-vpc.tf
   ├── modules
   │   ├── main.tf
   │   ├── outputs.tf
   │   └── variables.tf
   └── prod
       └── prod-vpc.tf
```

![terraform modules](terraform-modules.png)

- Go to the `modules/main.tf` file, add the followings.

```bash
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "module_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "terraform-vpc-${var.environment}"
  }
}

resource "aws_subnet" "public_subnet" {
  cidr_block = var.public_subnet_cidr
  vpc_id = aws_vpc.module_vpc.id
  tags = {
    Name = "terraform-public-subnet-${var.environment}"
  }
}

resource "aws_subnet" "private_subnet" {
  cidr_block = var.private_subnet_cidr
  vpc_id = aws_vpc.module_vpc.id
  tags = {
    Name = "terraform-private-subnet-${var.environment}"
  }
}
```

- Go to the `modules/variables.tf` file, add the followings.

```bash
variable "environment" {
  default = "oliver"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
  description = "this is our vpc cidr block"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
  description = "this is our public subnet cidr block"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
  description = "this is our private subnet cidr block"
}
```

- Go to the `modules/outputs.tf` file, add the followings.

```bash
output "vpc_id" {
  value = aws_vpc.module_vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.module_vpc.cidr_block
}

output "public_subnet_cidr" {
  value = aws_subnet.public_subnet.cidr_block
}

output "private_subnet_cidr" {
  value = aws_subnet.private_subnet.cidr_block
}
```

- Go to the `dev/dev-vpc.tf` file, add the followings.

```bash
module "tf-vpc" {
  source = "../modules"
  environment = "DEV"
  }

output "vpc-cidr-block" {
  value = module.tf-vpc.vpc_cidr
}
```

- Go to the `prod/prod-vpc.tf` file, add the followings.

```bash
module "tf-vpc" {
  source = "../modules"
  environment = "PROD"
  }

output "vpc-cidr-block" {
  value = module.tf-vpc.vpc_cidr
}
```

- Go to the `dev` folder and run the command below.

```bash
terraform init

terraform apply
```

- Go to the AWS console and check the VPC and subnets.

- Go to the `prod` folder and run the command below.

```bash
terraform init

terraform apply
```

- Go to the AWS console and check the VPC and subnets.

### Destroy

The `terraform destroy` command terminates resources defined in your Terraform configuration. This command is the reverse of terraform apply in that it terminates all the resources specified by the configuration. It does not destroy resources running elsewhere that are not described in the current configuration. 

- Go to the `prod` and  `dev` folders and run the command below.

```bash
terraform destroy -auto-approve
```

- Visit the EC2, S3, DynamoDB, IAM, VPC  console to see all the resources are deleted if not delete manually. Because all tf configuration files are related each other so sometimes terraform destroy will not work. Don't forget to deregister ami and delete the snapshot (when you creating an ami, AWS create a snapshot of your instance) of your instance. Finally delete your terraform EC2 instance.

