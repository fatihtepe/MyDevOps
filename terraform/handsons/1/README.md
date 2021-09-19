# Hands-on Terraform-01 : Terraform Installation and Basic Operations

Purpose of the this hands-on training is to give students the knowledge of basic operations in Terraform.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- Install Terraform

- Build AWS Infrastructure with Terraform

## Outline

- Part 1 - Install Terraform

- Part 2 - Build AWS Infrastructure with Terraform

## Part 1 - Install Terraform

- Launch an EC2 instance using the Amazon Linux 2 AMI with security group allowing SSH connections.

- Connect to your instance with SSH.

```bash
ssh -i .ssh/call-training.pem ec2-user@ec2-3-133-106-98.us-east-2.compute.amazonaws.com
```

- Update the installed packages and package cache on your instance.

```bash
$ sudo yum update -y
```

- Install yum-config-manager to manage your repositories.

```bash
$ sudo yum install -y yum-utils
```
- Use yum-config-manager to add the official HashiCorp Linux repository to the directory of /etc/yum.repos.d.

```bash
$ sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
```

- Install Terraform.

```bash
$ sudo yum -y install terraform
```

- Verify that the installation

```bash
$ terraform version
```
- list Terraform's available subcommands.

```bash
$ terraform -help
Usage: terraform [-version] [-help] <command> [args]

The available commands for execution are listed below.
The most common, useful commands are shown first, followed by
less common or more advanced commands. If you are just getting
started with Terraform, stick with the common commands. For the
other commands, please read the help and docs before usage.

Common commands:
    apply              Builds or changes infrastructure
...

```

- Add any subcommand to terraform -help to learn more about what it does and available options.

```bash
$ terraform -help apply
or
$ terraform apply -help
```

## Part 2 - Build AWS Infrastructure with Terraform

### Prerequisites

- An AWS account.

- The AWS CLI installed. 

- Your AWS credentials configured locally. 

```bash
$ aws configure
```

- Hard-coding credentials into any Terraform configuration is not recommended, and risks secret leakage should this file ever be committed to a public version control system. Using AWS credentials in EC2 instance is not recommended.

- We will use IAM role (temporary credentials) for accessing your AWS account. 

### Create a role in IAM management console.

- Secure way to make API calls is to create a role and assume it. It gives temporary credentials for access your account and makes API calls.

- Go to the IAM service, click "roles" in the navigation panel on the left then click "create role". 

- Under the use cases, Select `EC2`, click "Next Permission" button.

- In the search box write EC2 and select `AmazonEC2FullAccess` then click "Next: Tags" and "Next: Reviews".

- Name it `terraform`.

- Attach this role to your EC2 instance. 

### Write your first configuration

- The set of files used to describe infrastructure in Terraform is known as a Terraform configuration. You'll write your first configuration file to launch a single AWS EC2 instance.

- Each configuration should be in its own directory. Create a directory ("terraform-aws") for the new configuration and change into the directory.

```bash
$ mkdir terraform-aws && cd terraform-aws && touch main.tf
```

- Create a file named `main.tf` for the configuration code and copy and paste the following content. 

```txt
provider "aws" {
  region  = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.38.0"
    }
  }
}

resource "aws_instance" "tf-ec2" {
  ami           = "ami-0742b4e673072066f"
  instance_type = "t2.micro"
  tags = {
    "Name" = "created-by-tf"
  }
}
```

- Install the HashiCorp Terraform extension in VSCode.

- Explain the each block via the following section.

### Providers

The `provider` block configures the name of provider, in our case `aws`, which is responsible for creating and managing resources. A provider is a plugin that Terraform uses to translate the API interactions with the service. A provider is responsible for understanding API interactions and exposing resources. Because Terraform can interact with any API, you can represent almost any infrastructure type as a resource in Terraform.

The `profile` attribute in your provider block refers Terraform to the AWS credentials stored in your AWS Config File, which you created when you configured the AWS CLI. HashiCorp recommends that you never hard-code credentials into `*.tf configuration files`.

- Note: If you delete your AWS credentials from provider block, Terraform will automatically search for saved API credentials (for example, in ~/.aws/credentials) or IAM instance profile credentials. 

### Resources

The `resource` block defines a piece of infrastructure. A resource might be a physical component such as an EC2 instance.

The resource block must have two required data for EC2. : the resource type and the resource name. In the example, the resource type is `aws_instance` and the local name is `tf-ec2`. The prefix of the type maps to the provider. In our case "aws_instance" automatically tells Terraform that it is managed by the "aws" provider.

The arguments for the resource are within the resource block. The arguments could be things like machine sizes, disk image names, or VPC IDs. For your EC2 instance, you specified an AMI for `Amazon Linux 2` and instance type will be `t2.micro`.

![terraform-workflow](terraform-workflow.png)


### Initialize the directory

When you create a new configuration you need to initialize the directory with `terraform init`.

- Initialize the directory.

```bash
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/aws versions matching "3.9.0"...
- Installing hashicorp/aws v3.9.0...
- Installed hashicorp/aws v3.9.0 (signed by HashiCorp)

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Terraform downloads the `aws` provider and installs it in a hidden subdirectory (.terraform) of the current working directory. The output shows which version of the plugin was installed.

### Create infrastructure

- run `terraform plan`. You should see an output similar to the one shown below.

```bash
$ terraform plan

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.sample-resource will be created
  + resource "aws_instance" "tf-ec2" {
      + ami                          = "ami-04d29b6f966df1537"
      + arn                          = (known after apply)
      + associate_public_ip_address  = (known after apply)
      + availability_zone            = (known after apply)
      + cpu_core_count               = (known after apply)
      + cpu_threads_per_core         = (known after apply)
      + get_password_data            = false
      + host_id                      = (known after apply)
      + id                           = (known after apply)
      + instance_state               = (known after apply)
      + instance_type                = "t2.micro"
      + ipv6_address_count           = (known after apply)
      + ipv6_addresses               = (known after apply)
      + key_name                     = (known after apply)
      + network_interface_id         = (known after apply)
      + outpost_arn                  = (known after apply)
      + password_data                = (known after apply)
      + placement_group              = (known after apply)
      + primary_network_interface_id = (known after apply)
      + private_dns                  = (known after apply)
      + private_ip                   = (known after apply)
      + public_dns                   = (known after apply)
      + public_ip                    = (known after apply)
      + security_groups              = (known after apply)
      + source_dest_check            = true
      + subnet_id                    = (known after apply)
      + tenancy                      = (known after apply)
      + volume_tags                  = (known after apply)
      + vpc_security_group_ids       = (known after apply)

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
        }

      + network_interface {
          + delete_on_termination = (known after apply)
          + device_index          = (known after apply)
          + network_interface_id  = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform can't guarantee that exactly these actions will be performed if "terraform apply" is subsequently run.
```

- This output shows the execution plan, describing which actions Terraform will take in order to change real infrastructure to match the configuration. 

- Run `terraform apply`. You should see an output similar to the one shown above.

```bash
terraform apply
```

- Terraform will wait for your approval before proceeding. If anything in the plan seems incorrect it is safe to abort (ctrl+c) here with no changes made to your infrastructure.

- If the plan is acceptable, type "yes" at the confirmation prompt to proceed. Executing the plan will take a few minutes since Terraform waits for the EC2 instance to become available.

```txt
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_instance.tf-example-ec2: Creating...
aws_instance.tf-example-ec2: Still creating... [10s elapsed]
aws_instance.tf-example-ec2: Still creating... [20s elapsed]
aws_instance.tf-example-ec2: Still creating... [30s elapsed]
aws_instance.tf-example-ec2: Still creating... [40s elapsed]
aws_instance.tf-example-ec2: Creation complete after 43s [id=i-080d16db643703468]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

- Visit the EC2 console to see the created EC2 instance.

### Inspect state

- When you applied your configuration, Terraform fetched data from resources into a file called terraform.tfstate. It keeps track of resources' metadata.

### Manually Managing State

- Terraform has a command called `terraform state` for advanced state management. For example, if you have a long state file (detailed) and you just want to see the name of your resources, which you can get them by using the `list` subcommand.

```bash
$ terraform state list
aws_instance.tf-ec2
```

### Creating a AWS S3 bucket

- Create a S3 bucket. Go to the `main.tf` and add the followings.

```tf
provider "aws" {
  region  = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.38.0"
    }
  }
}

resource "aws_instance" "tf-ec2" {
  ami           = "ami-0742b4e673072066f"
  instance_type = "t2.micro"
  key_name      = "mk"    # write your pem file without .pem extension>
  tags = {
    "Name" = "tf-ec2"
  }
}

resource "aws_s3_bucket" "tf-s3" {
  bucket = "oliver-tf-test-bucket-addwhateveryouwant"
  acl    = "private"
}
```

- Write your pem file without .pem extension and change the "addwhateveryouwant" part of the bucket name. Because bucket name must be unique.

- Run the command `terraform plan` and `terraform apply`.

```bash
terraform plan

terraform apply
```

```txt
Error: Error creating S3 bucket: AccessDenied: Access Denied
        status code: 403, request id: 8C5E290CD1CD3F71, host id: NT6nPSh0nW9rripGZrOAo48qJpZ2yToKCiGxDl6gfKIXY97uVH67lcvBiQjX9bsJRX3cL1oNVNM=
```

- Attach S3FullAccess policy to the "terraform" role.

```bash
terraform apply -auto-approve
```

- `-auto-approve` means to skip the approval of plan before applying.

- Go to the AWS console, check the S3 bucket. Then check the `terraform.tfstate` and `terraform.tfstate.backup` file.

```bash
terraform plan -out=justs3
```
- Now we have just an S3 bucket in justs3. Check that `terraform.tfstate` file has both ec2 and s3 bucket (real infrastructure). If we apply justs3 file it will delete the EC2 instance and modify the tfstate file. You can save your plans with -out flag.

```bash
terraform apply justs3
```

### Terraform Commands

- Validate command.

- Go to the terminal and run `terraform validate`. It validates the Terraform files syntactically correct and internally consistent.  

```bash
terraform validate
```

- Go to `main.tf` file and delete last curly bracket "}" and key_name's last letter (key_nam). And Go to terminal and run the command `terraform validate`. After taking the errors correct them. Then run the command again.

```bash
$ terraform validate 

Error: Argument or block definition required

  on tf-example.tf line 20, in resource "aws_s3_bucket" "tf-s3":

An argument or block definition is required here.

$ terraform validate 

Error: Unsupported argument

  on tf-example.tf line 9, in resource "aws_instance" "tf-example-ec2":
   9:     key_nam      = "mk"

An argument named "key_nam" is not expected here. Did you mean "key_name"?

$ terraform validate 
Success! The configuration is valid.
```

- Go to `main.tf` file and copy the EC2 instance block and paste it. And Go to terminal and run the command `terraform validate`. After taking the errors correct them. Then run the command again.

$ terraform validate 
│ Error: Duplicate resource "aws_instance" configuration
│ 
│   on main.tf line 24:
│   24: resource "aws_instance" "tf-ec2" {
│ 
│ A aws_instance resource named "tf-ec2" was already declared at main.tf:15,1-33. Resource names must be unique per type in
│ each module.

- fmt command.

- Go to `main.tf` file and delete the second EC2 instance.

- Go to `main.tf` file and add random indentations. Then go to terminal and run the command `terraform fmt`. "terraform fmt" command reformat your configuration file in the standard style.

```bash
terraform fmt
```

- Now, show `main.tf` file. It was formatted again.

- Go to the terminal and run `terraform console`.This command provides an interactive command-line console for evaluating and experimenting with expressions. This is useful for testing interpolations before using them in configurations, and for interacting with any values currently saved in state. You can see the attributes of resources in tfstate file and check built in functions before you write in your configuration file. Lets create a file under the terraform-aws directory and name it "cloud" and paste "hello devops engineers". Run the following commands.

```bash
terraform console
> aws_instance.tf-ec2
> aws_instance.tf-ec2.private_ip
> min (1,2,3)
> lower("HELLO")
> file("${path.module}/cloud")
> aws_s3_bucket.tf-s3
> aws_s3_bucket.tf-s3.bucket
> exit or (ctrl+c)
```

- show command.

- Go to the terminal and run `terraform show`.

 You can see tfstate file or plan in the terminal. It is more readable than `terraform.tfstate`.

```bash
terraform show
```

- graph command.

- Go to the terminal and run `terraform graph`. It creates a visual graph of Terraform resources. The output of "terraform graph" command is in the DOT format, which can easily be converted to an image by making use of dot provided by GraphViz.

- Copy the output and paste it to the ` https://dreampuf.github.io/GraphvizOnline `. Then display it. If you want to display this output in your local, you can download graphviz (`sudo yum install graphviz`) and take a `graph.svg` with the command `terraform graph | dot -Tsvg > graph.svg`.

```bash
terraform graph
```

- output command.

- Now add the followings to the `main.tf` file.  Then run the commands `terraform apply or terraform refresh` and `terraform output`. `terraform output` command is used for reading an output from a state file. It reads an output variable from a Terraform state file and prints the value. With no additional arguments, output will display all the outputs for the (parent) root module.  If NAME is not specified, all outputs are printed.

```bash
output "tf-example-public-ip" {
  value = aws_instance.tf-ec2.public_ip
}

output "tf-example-s3-meta" {
  value = aws_s3_bucket.tf-s3.region
}
```

```bash
terraform apply
terraform output
terraform output -json
terraform output tf-example-public-ip
```

- refresh command.

- The `terraform refresh` command is used to update the state file with the real-world infrastructure. This can be used to detect any drift from the last-known state, and to update the state file. First, check the current state of your resources with `terraform state list`. Then go to the AWS console and delete your S3 bucket `oliver-tf-test-bucket-addwhateveryouwant`. Display the state list again and refresh the state. Run the following commands.

```bash
$ terraform state list
aws_instance.tf-example-ec2
aws_s3_bucket.tf-example-s3

$ terraform state list
aws_instance.tf-example-ec2
aws_s3_bucket.tf-example-s3

$ terraform refresh
aws_instance.tf-example-ec2: Refreshing state... [id=i-02938164282a9c741]
aws_s3_bucket.tf-example-s3: Refreshing state... [id=oliver-tf-test-bucket]

Outputs:

tf-example-public-ip = "54.237.127.221"
tf-example-s3-meta = "us-east-1"

$ terraform state list
aws_instance.tf-example-ec2
```

- Now, you can see the differences between files `terraform.tfstate` and `terraform.tfstate.backup`. From tfstate file S3 bucket is deleted but in backup file you can see the S3 bucket.

- Run terraform apply -auto-approve and create S3 bucket again.

```bash
terraform apply -auto-approve
```

-  Go to the `main.tf` file and make the changes. We will change the ami id with the Ubuntu instance. Also change the value of EC2 instance tag and name of the S3 bucket.

```bash
resource "aws_instance" "tf-ec2" {
    - ami           = "ami-0742b4e673072066f"
    + ami           = "ami-042e8287309f5df03"
    instance_type = "t2.micro" 
    key_name      = "mk"    #<pem file>
    tags = {
      - Name = "tf-ec2"
      + Name = "tf-ec2-ubuntu"
  }
}

resource "aws_s3_bucket" "tf-s3" {
  + bucket = "oliver-tf-bucket-addwhateveryouwant-new"
  - bucket = "oliver-tf-bucket-addwhateveryouwant"
  acl    = "private"
}
```

- Run the command `terraform apply -auto-approve` and check the AWS console, the old S3 bucket and EC2 were destroyed and terraform created new ones.

```bash
terraform apply -auto-approve
```

- Make the new changes in the `main.tf` file.

```bash
output "tf-example-private-ip" {
  value = aws_instance.tf-ec2.private_ip
}
```

- Run the command `terraform apply -refresh=false`. 

```bash
$ terraform apply -refresh=false

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:

Terraform will perform the following actions:

Plan: 0 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + tf-example-private-ip = "172.31.22.95"

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes


Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

```bash
terraform destroy
```