# Terraform Associate Certification Notes

- `Infrastructure as Code` You write and execute the code to define, deploy, update, and destroy your infrastructure
- IaC makes changes `idempotent, consistent, repeatable, and predictable` benefits of IaC are `automation`, `Reusability of the code` and `Versioning`
- `IaC makes it easy to provision and apply infrastructure configurations, saving time`. It standardizes workflows across different infrastructure providers (e.g., VMware, AWS, Azure, GCP, etc.) by using a common syntax across all of them.
- The `idempotent characteristic` provided by IaC tools ensures that, even if the same code is applied multiple times, the result remains the same.
- IaC can be applied throughout the lifecycle, both on the initial build, as well as throughout the life of the infrastructure. Commonly, these are referred to as Day 0 and Day 1 activities. `Day 0` code provisions and configures your initial infrastructure. `Day 1` refers to OS and application configurations you apply after you’ve initially built your infrastructure.
- `the use cases of Terraform are` :

    ```markdown
    Heroku App Setup
    Multi-Tier Applications
    Self-Service Clusters
    Software Demos
    Disposable Environments
    Software Defined Networking
    Resource Schedulers
    Multi-Cloud Deployment
    ```

- `To deploy infrastructure with Terraform:`

    ```markdown
    Scope - Identify the infrastructure for your project.
    **Author** - Write the configuration for your infrastructure.
    **Initialize** - Install the plugins Terraform needs to manage the infrastructure.
    **Plan** - Preview the changes Terraform will make to match your configuration.
    **Apply** - Make the planned changes.
    ```

- `Advantages of Terraform are`:

    ```markdown
    Platform Agnostic
    State Management
    Operator Confidence
    ```

- Terraform builds a graph of all your resources, and parallelizes the creation and modification of any non-dependent resources. Because of this, Terraform builds infrastructure as efficiently as possible, and operators get insight into dependencies in their infrastructure.
- `multi-cloud deployment` : Provisioning your infrastructure into multiple cloud providers to increase fault-tolerance of your applications.
- `cloud-agnostic in terms of provisioning tools` : cloud-agnostic and allows a single configuration to be used to manage multiple providers, and to even handle cross-cloud dependencies. `Terraform is cloud-agnostic` It simplifies management and orchestration, helping operators build large-scale multi-cloud infrastructures.
- `Terraform state(it is mandatory feature you can not run terraform without state file)`Every time you run Terraform, it records information about what infrastructure it created in a Terraform state file. `terraform.tfstate` This file contains a custom JSON format that records a mapping from the Terraform resources in your configuration files to the representation of those resources in the real world.
- `The purpose of the Terraform State` :

    ```markdown
    Mapping to the Real World
    Metadata
    Performance `stores a cache of the attribute values for all resources in the state.`
    Syncing
    ```

- With a fully-featured state backend, Terraform can use remote locking as a measure to avoid two or more different users accidentally running Terraform at the same time, and thus ensure that each Terraform run begins with the most recent updated state.
- The special terraform configuration block type is used to `configure some behaviours` of Terraform itself, `such as requiring a minimum Terraform version` to apply your configuration.

    ```markdown
    terraform {
      # ...
    }
    ```

- `Within a terraform block`, `only constant values can be used`; arguments may not refer to named objects such as resources, `input variables`(make code dynamic by stopping to use static values), and may not use any of the Terraform language built-in functions.
- `A provider is a plugin` that Terraform uses to translate the API interactions with the service. A provider is responsible for understanding API interactions and exposing resources. Because Terraform can interact with any API, you can represent almost any infrastructure type as a resource in Terraform.
- Both Terraform CLI and Terraform Cloud offer a feature called "workspaces".

    Terraform Cloud maintains the state version and run history for each workspace

    - Terraform Cloud manages infrastructure collections with workspace whereas CLI manages collections of infrastructure resources with a persistent working directory
    - CLI workspaces are alternative state files in the same working directory

- There are also `two "meta-arguments" that are defined by Terraform` itself and available for all `provider` blocks:
    - `[alias`, for using the same provider with different configurations for different resources](https://www.terraform.io/docs/language/providers/configuration.html#alias-multiple-provider-configurations)
    - `[version`, which we no longer recommend](https://www.terraform.io/docs/language/providers/configuration.html#provider-versions) (use [provider requirements](https://www.terraform.io/docs/language/providers/requirements.html) instead)
- Each time a new provider is added to configuration -- either explicitly via a provider block or by adding a resource from that provider -- Terraform must initialize the provider before it can be used. `Initialization downloads and installs the provider's plugin so that it can later be executed.`
- Provider initialization is one of the actions of `terraform init`. Running this command will download and initialize any providers that are not already initialized.
- `Providers downloaded by terraform init are only installed for the current working directory` other working directories can have their own installed provider versions.
- `terraform init` cannot automatically download providers that are not distributed by HashiCorp.
- `To constrain the provider version as suggested`, add a required_providers block inside a terraform block:

    ```markdown
    terraform {
      required_providers {
        aws = "~> 1.0"
      }
    }
    ```

- `terraform init --upgrade`  upgrade to the latest acceptable version of each provider. This command also upgrades to the latest versions of all Terraform modules.
- `ways you can configure provider versions`

```markdown
`With required_providers blocks under terraform block`

terraform {
  required_providers {
    aws = "~> 1.0"
  }
}

`Provider version constraints can also be specified`
`using a version argument within a provider block`

provider {
  version= "1.0"
}
```

- `alias` You can optionally define multiple configurations for the same provider, and select which one to use on a per-resource or per-module basis.
- `Some of the example of Multiple Provider instances scenarios`:

    ```markdown
    a. multiple regions for a cloud platform
    b. targeting multiple Docker hosts
    c. multiple Consul hosts, etc.
    ```

- To include multiple configurations for a given provider, include multiple provider blocks with the same provider name, but `set the alias meta-argument to an alias name to use for each additional configuration`.

    ```markdown
    # The default provider configuration
    provider "aws" {
      region = "us-east-1"
    }

    # Additional provider configuration for west coast region
    provider "aws" {
      alias  = "west"
      region = "us-west-2"
    }
    ```

- `Third-party plugins should be manually installed.`
    - Install third-party providers by placing their plugin executables in the user plugins directory. The user plugins directory is in one of the following locations, depending on the host operating system
    - Once a plugin is installed, terraform init can initialize it normally. You must run this command from the directory where the configuration files are located.
- `location of the user plugins directory`

```markdown
Windows                     %APPDATA%\terraform.d\plugins
All other systems           ~/.terraform.d/plugins
```

- naming scheme for provider plugins `terraform-provider-<NAME>_vX.Y.Z`
- The `CLI configuration file` configures per-user settings for CLI behaviors, which apply across all Terraform working directories. It is named either `.terraformrc`(all other systems) or `terraform.rc` (windows)
- `The location of the Terraform CLI` configuration file can also be specified using the `TF_CLI_CONFIG_FILE` environment variable.
- `Provider Plugin Cache`  `By default`, terraform init downloads plugins into a subdirectory of the working directory so that each working directory is self-contained. As a consequence, if you have multiple configurations that use the same provider then a separate copy of its plugin will be downloaded for each configuration.
    - Given that provider plugins can be quite large (on the order of hundreds of megabytes), this default behavior can be inconvenient for those with slow or metered Internet connections.
    - Therefore `Terraform optionally allows the use of a local directory as a shared plugin cache`, which then allows each distinct plugin binary to be downloaded only once.
- `Provider Plugin Cache` To enable the plugin cache, use the plugin_cache_dir setting in the CLI configuration file.

    ```markdown
    plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"

    # Alternatively, the `TF_PLUGIN_CACHE_DIR` environment\
    #variable can be used to enable caching or to override\
    #an existing cache directory within a particular shell session:
    ```

- `User responsible to clean cache directory` Terraform will never itself delete a plugin from the plugin cache once it's been placed there. Over time, as plugins are upgraded, the cache directory may grow to contain several unused versions which must be manually deleted.
- Terraform analyzes any expressions within a resource block to find references to other objects and treats those references as implicit ordering requirements when creating, updating, or destroying resources.
- `terraform fmt` command is used to rewrite Terraform configuration files to a `canonical format and style` and makes files to have consistent formatting. `terraform fmt` does not fail because of the state lock. It works!!!

    ```markdown
    -recursive  Also process files in subdirectories.
    By default, only the given directory (or current directory)
     is processed.
    ```

- The canonical format may change in minor ways between Terraform versions, so after upgrading Terraform we recommend to proactively run `terraform fmt` on your modules along with any other changes you are making to adopt the new version.
- `By default, fmt scans the current directory for configuration files.`
- You are formatting the configuration files and the flag you should use to see the differences `terraform fmt -diff`
- You are formatting configuration files in a lot of directories and you don’t want to see the list of file changes. `terraform fmt -list=false`
- `terraform validate` command validates the configuration files in a directory, referring only to the configuration and not accessing any remote services such as remote state, provider APIs, etc. Validate runs checks that `verify whether a configuration is syntactically valid and internally consistent, regardless of any provided variables or existing state`. It is thus primarily useful for general verification of reusable modules, including correctness of attribute names and value types.
- To `verify configuration in the context of a particular run` (a particular target workspace, input variable values, etc), `use the` `terraform plan` command instead, which includes an implied validation check. `Terraform plan` looks at code and identifies if there are any syntax errors or `missing arguments and errors` out and user has to fix these before issuing next terraform plan.
- `terraform apply` does not validates the terraform syntax like missing arguments.
- `terraform show`  `inspect the current state of the infrastructure applied` `terraform show` When you applied your configuration, Terraform wrote data into a file called `terraform.tfstate`. This file now contains the IDs and properties of the resources Terraform created so that it can manage or destroy those resources going forward.
- `terraform state list` state file is too big and you want to list the resources from your state. `shows the resources within a terraform state.`
- `plug-in based architecture` Defining additional features as plugins to your core platform or core application. This provides extensibility, flexibility and isolation
- Provisioners are executed at the time when the resource is created or destroyed not during updating. ⇒ creation provisioner and destroy provisioner.
- `Provisioners` If you need to do some initial setup on your instances, then provisioners let you upload files, run shell scripts, or install and trigger other software like configuration management tools, etc.
    - `local-exec` provisioner executing a command locally on your machine running Terraform. We use this when we need to do something on our local machine without needing any external URL. Hashicorp suggests using `local-exec` to run scripts on local machines with `null_resources`.

        ```markdown
        resource "aws_instance" "example" {
          ami           = "ami-b374d5a5"
          instance_type = "t2.micro"

          provisioner "local-exec" {
            command = "echo hello > hello.txt"
          }
        }
        ```

    - `remote-exec`invokes a script on a remote resource after it is created. This can be used to run a configuration management tool, bootstrap into a cluster, etc. (runs a script on a remote resource after it is created)In order to use a remote-exec provisioner, you must choose an `ssh` or `winrm` connection in the form of a connection block within the provisioner.

        ```markdown
        provider "aws" {
          profile = "default"
          region  = "us-west-2"
        }
        resource "aws_key_pair" "example" {
          key_name   = "examplekey"
          public_key = file("~/.ssh/terraform.pub")
        }
        resource "aws_instance" "example" {
          key_name      = aws_key_pair.example.key_name
          ami           = "ami-04590e7389a6e577c"
          instance_type = "t2.micro"
        connection {
            type        = "ssh"
            user        = "ec2-user"
            private_key = file("~/.ssh/terraform")
            host        = self.public_ip
          }
        provisioner "remote-exec" {
            inline = [
              "sudo amazon-linux-extras enable nginx1.12",
              "sudo yum -y install nginx",
              "sudo systemctl start nginx"
            ]
          }
        }
        ```

- If a resource successfully creates but fails during provisioning, Terraform will error and mark the resource as `"tainted".` Terraform also does not automatically roll back and destroy the resource during the apply when the failure happens, because that would go against the execution plan: the execution plan would've said a resource will be created, but does not say it will ever be deleted. `If you create an execution plan with a tainted resource, however, the plan will clearly state that the resource will be destroyed because it is tainted`.
- You can manually taint a resource

```markdown
terraform taint [resource.id](http://resource.id/)
```

- This command will not modify infrastructure, but does modify the state file in order to mark a resource as tainted. Once a resource is marked as tainted, the next plan will show that the resource will be destroyed and recreated and the next apply will implement this change.
- The `terraform destroy` command terminates resources defined in your Terraform configuration. This command is the reverse of `terraform apply` in that it terminates all the resources specified by the configuration. It does not destroy resources running elsewhere that are not described in the current configuration.
- The `terraform plan` does not actually result in changes to the state file.
- The `terraform refresh` command reads the current settings from all managed remote objects and `updates the Terraform state` to match.
- `Data sources` allow data to be fetched or computed for use elsewhere in Terraform configuration. Use of data sources allows a Terraform configuration to make use of information defined outside of Terraform, or defined by another separate Terraform configuration.
- The Private Module Registry is available in all versions of Terraform except for Open Source.
- `By default, provisioners that fail will also cause the Terraform apply itself to fail` but how do you change it? `on_failure = "continue`
-

```markdown
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command  = "echo The server's IP address is ${self.private_ip}"
    on_failure = "continue"
  }
}
```

- You can define `destroy provisioner` with the parameter `when. = "destroy"`

    ```markdown
    provisioner "remote-exec" {
        when = "destroy"

        # <...snip...>
    }
    ```

- The required_providers setting is a map specifying a `version constraint` for each provider required by your configuration.

    ```markdown
    terraform {
      required_providers {
        aws = ">= 2.7.0"
      }
    }
    ```

- `set both a lower and upper bound on versions for each provider?`

    ```markdown
    ~>
    terraform {
      required_providers {
        aws = "~> 2.7.0"
      }
    }
    ```

- `try experimental features` In releases where experimental features are available, you can enable them on a per-module basis by setting the experiments argument inside a terraform block:

    ```markdown
    terraform {
      experiments = [example]
    }
    ```

- Expressions in provisioner `blocks cannot refer to their parent resource by name`. The self object represents the provisioner's parent resource, and has all of that resource's attributes. For example, use `self.public_ip` to reference an aws_instance's public_ip attribute.
- If the state has drifted from the last time Terraform ran, refresh allows that drift to be detected.
- `version = “~> 1.0”` ⇒ Any version more than 1.0 and less than 2.0
- Terraform supports both cloud and on-premises infrastructure platforms
- Terraform assumes an empty default configuration for any provider that is not explicitly configured. A provider block can be empty
- The `required_version` setting `can` be used to `constrain which versions of the Terraform CLI can be used with your configuration`. If the running version of Terraform doesn't match the constraints specified, Terraform will produce an error and exit without taking any further actions.
- Terraform CLI versions and provider versions are independent of each other.
- `HashiCorp` `recommends` that you `never hard-code credentials into *.tf configuration files`. We are explicitly defining the default AWS config profile here to illustrate how Terraform should access sensitive credentials. If you leave out your AWS credentials, `Terraform will automatically search` for saved API credentials (for example, in `~/.aws/credentials`) or IAM instance profile credentials. This is cleaner when .tf files are checked into source control or if there is more than one admin user
- You are provisioning the infrastructure with the command terraform apply and you noticed one of the resources failed. You can taint the resource and the next apply will destroy the resource `terraform taint <[resource.id](http://resource.id/)>`
- The `terraform refresh command is used to reconcile the state Terraform knows about (via its state file) with the real-world infrastructure`. This can be used to detect any drift from the last-known state, and to update the state file.
- When calling a child module, values can be passed to the module to be used within the module itself. `servers = 5` ⇒value of input variable
- `terraform import` command is used to import existing resources into Terraform. Terraform is able to import existing infrastructure. This allows you take resources you've created by some other means and bring it under Terraform management. This is a great way to slowly transition infrastructure to Terraform, or to be able to be confident that you can use Terraform in the future if it potentially doesn't support every feature you need today. `terraform import [options] ADDRESS ID`
- To import a resource, first write a resource block for it in your configuration, establishing the name by which it will be known to Terraform. You can only import one resource at a time.
- Each Terraform configuration has an associated `backend` that defines how operations are executed and where persistent data such as the `Terraform state are stored`.  The persistent data stored in the backend belongs to a `workspace`. `Initially the backend has only one workspace, called "default"`, and thus there is only one Terraform state associated with that configuration.
- Certain backends support multiple named workspaces, allowing multiple states to be associated with a single configuration. terraform workspaces help in adding/allowing multiple state files for a single configuration.
- `terraform workspace list` is the command to list the workspaces.
- `terraform workspace new <name>` is the command to create a new workspace.
- `terraform workspace show` is the command to show the current workspace.
- `terraform workspace select <workspace name>` is the command to switch the workspace. you can switch the workspace while working with default workspace to workspace X.
- `terraform workspace delete <workspace name>` is the command to delete the workspace.
- `You can't ever delete default workspace`
- You are working on the different workspaces and you want to use a different number of instances based on the workspace

    ```markdown
    resource "aws_instance" "example" {
      count = "${terraform.workspace == "default" ? 5 : 1}"

      # ... other arguments
    }
    ```

- You are working on the different workspaces and you want to use tags based on the workspace.

    ```markdown
    resource "aws_instance" "example" {
      tags = {
        Name = "web - ${terraform.workspace}"
      }

      # ... other arguments
    }
    ```

- `Workspaces` can create a parallel, distinct copy of a set of infrastructure in order to test a set of changes before modifying the main production infrastructure.
- `terraform state list` will list all resources in the state file matching the given addresses (if any). If no addresses are given, all resources are listed.
- `Filtering by Module`

    ```markdown
    $ terraform state list module.elb
    module.elb.aws_elb.main
    module.elb.module.secgroups.aws_security_group.sg
    ```

- `terraform state show 'resource name'` is the command that shows the attributes of a single resource in the state file
- Terraform has detailed logs which can be enabled by setting the `TF_LOG` environment variable to any value.
- `TRACE is the most verbose and it is the default` if TF_LOG is set to something other than a log level name.
- To persist logged output `you can set TF_LOG_PATH in order to force the log to always be appended to a specific file` when logging is enabled.
- `Note that even when TF_LOG_PATH is set, TF_LOG must be set in order for any logging to be enabled.`
- `If Terraform ever crashes` (a "panic" in the Go runtime), it saves a log file with the debug logs from the session as well as the panic message and backtrace to `crash.log`.
- The most interesting part of a crash log is the panic message itself and the backtrace immediately following. So the `first thing to do is to search the file for panic`
- There are two primary methods to separate state between environments: `directories` and `workspaces`
- `Directory separated environment` rely on duplicate Terraform code, which `may be useful if your deployments need differ`, for example to test infrastructure changes in development. But they can run the `risk of creating drift between the environments over time`.
- `Workspace-separated environments use the same Terraform code` but have `different state files`, which is `useful` if you want your environments to stay as `similar to each other as possible`, for example if you are providing development infrastructure to a team that wants to simulate running in production.
- `Terraform state pull` is the `command` to pull the `remote state` and it will  download the state from its current location and output the raw format to stdout.
- The `terraform state push` command is used to `manually upload a local state file to remote state`. This command `also works with local state`.
- `Terraform taint` command `will not modify infrastructure, but does modify the state file` in order to mark a resource as tainted. `Once a resource is marked as tainted`, the `next plan will show that the resource will be destroyed and recreated and the next apply will implement this change`.
- How do you migrate your existing resources to terraform and start using it? `You should use terraform import and modify the infrastrcuture in the terraform files and do the terraform workflow (init, plan, apply)`.
- When you are working with the workspaces how do you access the current workspace in the configuration files? `${terraform.workspace}`.
- `For local state`, Terraform `stores` the workspace states in a `directory` called `terraform.tfstate.d`.
- `For remote state`, the workspaces are `stored` directly in the configured `backend`.
- The `terraform state rm` command is used to remove items from the Terraform state. `This command can remove single resources, single instances of a resource, entire modules, and more`.
- `terraform state mv` command create a backup copy of terraform state by default.
- `terraform state mv 'module.app' 'module.parent.module.app'` The `terraform state mv` command is used to move items in a Terraform state. This command can also move items to a completely different state file, enabling efficient refactoring. Also, you can `rename` a resource in the terraform state file.
- A `Terraform module` is a `set of Terraform configuration files` in a `single directory`.
- The `Terraform Registry` makes it simple to `find and use modules`.
- By default, `only verified modules are shown in search results`. `Verified` modules are reviewed `by HashiCorp` to ensure `stability and compatibility`.
- By using the `filters, you can view unverified modules` as well.
- To `download any modules`, you need to add any module in the `configuration file` like below, then `terraform init` command will download and cache any modules referenced by a configuration.

    ```markdown
    module "consul" {
      source = **"hashicorp/consul/aws"** # reference registry mod.
      version = "0.1.0"
    }
    ```

- To reference a private registry module same syntax above but `"[app.terraform.io/example_corp/vpc/aws](http://app.terraform.io/example_corp/vpc/aws)"`
- `source and version` to use module.
- The `terraform recommends` that all modules must follow `semantic versioning`
- Benefits of modules are:

```markdown
* Organize configuration
* Encapsulate configuration
* Re-use configuration
* Provide consistency and ensure best practices
```

- Terraform supports a variety of remote sources, including the `Terraform Registry`, `most version control systems`, `HTTP URLs`, and `Terraform Cloud or Terraform Enterprise private module registries`.
- Source types for calling modules are:

```markdown
Local paths
Terraform Registry
GitHub
Generic Git, Mercurial repositories
Bitbucket
HTTP URLs
S3 buckets
GCS buckets
```

- You access output variables from the modules by referring `module.<MODULE NAME>.<OUTPUT NAME>`
- `Module outputs` are usually `either passed to other parts of your configuration`, or defined as outputs in your `root module`. [`outputs.tf`](http://outputs.tf/) will need to contain:

```markdown
output "ec2_instance_public_ips" {
  description = "Public IP addresses of EC2 instances"
  value       = module.ec2_instances.public_ip
}
```

- When installing a `local module`, Terraform will automatically notice changes to local modules `without having to re-run` `terraform init or terraform get`.
- When installing a `remote module`, Terraform will download it into the `.terraform directory` in your configuration's root directory.  `You should initialize with terraform init`.
- `A simple configuration` consisting of a single directory with `one or more .tf files is a module`.
- When using `a new module for the first time`, you must run either `terraform init` or `terraform get` to install the module.
- Terraform save modules `.terraform/modules`.
- `All modules require` a `source` argument, which is a meta-argument defined by Terraform CLI. `version` and `providers` optional.
- The core Terraform workflow has three steps:

```markdown
**Write** - Author infrastructure as code.
**Plan** - Preview changes before applying.
**Apply** - Provision reproducible infrastructure.
```

- Once the `backend is wired up`, a `Terraform Cloud API key` is all that's needed by team members to be able to edit config and run speculative plans against the latest version of the state file using all the remotely stored input variables.
- The `terraform init` command is used to `initialize a working directory containing Terraform configuration files`.
- It is safe to run `terraform init` command multiple times.
- `terraform init` is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control.
- `terraform init -upgrade` is the `flag` you should use to upgrade modules and plugins a part of their respective installation steps. you can used this command for upgrade/download the latest providers.
- `terraform init -backend=false` to skip backend initialization when you are doing initialization with terraform init.
- `terraform init -get=false` to skip child module installation.
- When you are doing initialization all plugins stored:

```markdown
On most operationg systems : ~/.terraform.d/plugins
on Windows                 : %APPDATA%\terraform.d\plugins
```

- `terraform init -get-plugins=false` skips plugin installation. If the installed plugins aren't sufficient for the configuration, init fails.
- `terraform validate` checks that verify whether a configuration is `syntactically valid and internally consistent`, regardless of any provided variables or existing state. It is thus primarily useful for general verification of reusable modules, including correctness of attribute names and value types.
- `terraform apply` command is used to apply the changes required `to reach the desired state of the configuration`, or the pre-determined set of actions generated by a terraform plan execution plan.
- Workspaces, managed with the terraform workspace command, isn't the same thing as Terraform Cloud's workspaces. Terraform Cloud workspaces act more like completely separate working directories.

- In Terraform Enterprise, a workspace can only be configured to a single VCS repo, however, multiple workspaces can use the same repo, if needed.

- A module that includes a module block like this is the calling module of the child module.

    ```markdown
    module "servers" {
      source = "./app-cluster"

      servers = 5
    }
    ```

- The label immediately after the module keyword is a local name, which the calling module can use to refer to this instance of the module.

- Sentinel Policies only available in Terraform Enterprise and Terraform Cloud paid tiers.
- `terraform apply -auto-approve` when you don’t want to do interactive approval!!!
- `terraform destroy` command is used to destroy the Terraform-managed infrastructure but it does not removes the state files.
- `Implicit dependency` terraform can automatically infer when one resource depends on another
- `Explicit dependency` sometimes there are dependencies between resources that are not visible to Terraform. The depends_on argument is accepted by any resource and accepts a list of resources to create explicit dependencies for.
- To save the execution plan `terraform plan -out=planname` you can use that file with apply  `terraform apply planname`.
- `terraform plan -detailed-exitcode` :

```markdown
* 0 = Succeeded with empty diff (no changes)
* 1 = Error
* 2 = Succeeded with non-empty diff (changes present)
```

- `terraform plan -destroy` the behavior of any terraform destroy command can be previewed
- `By default`, Terraform uses the `"local" backend`, which is the normal behavior of Terraform.
- The `local backend stores state on the local filesystem`, `locks that state using system APIs`, and performs operations locally. `"terraform.tfstate"` is the default path for the local backend

```markdown
terraform {
  backend "local" {
    path = "relative/path/to/terraform.tfstate"
  }
}
```

- If supported by your backend, Terraform will lock your state for all operations that could write state. This prevents others from acquiring the lock and potentially corrupting your state.
- `State locking happens automatically` on all operations that could write state. You won't see any message that it is happening. `If state locking fails, Terraform will not continue`.
- You can `disable state locking` for most commands with the `-lock` flag but it is `not recommended.`
- There are `two types of Backend`. `Standard and Enhanced`
- `Standard backend`: State management, functionality covered in State Storage & Locking. Terraform standard backend type support `does not support remote management system`
- `Enhanced`: Everything in standard plus remote operations.
- `Remote backends` allow Terraform to use a shared storage space for state data, so any member of your team can use Terraform to manage the same infrastructure. `S3` supports terraform remote backend.
- `Remote state` storage makes `collaboration easier and keeps state and secret information of your local disk`.
- If you want to move back to local state, you can remove the backend configuration block from your configuration and run terraform init again. Terraform will once again ask if you want to migrate your state back to local.
- `terraform refresh` does not modify infrastructure, but does modify the state file. If the state is changed, this may cause changes to occur during the next plan or apply. `Terraform refresh` is good on local environment but it does not affect on `terraform cloud`
- We always `recommend manually backing up your state as well`. You can do this by simply copying your `terraform.tfstate` file to another location.
- You do not need to specify every required argument in the backend configuration. `Omitting certain arguments may be desirable to avoid storing secrets, such as access keys, within the main configuration`. When some or all of the arguments are omitted, we call this a `partial configuration`.
- With a partial configuration, the remaining configuration arguments must be provided as part of [the initialization process](https://www.terraform.io/docs/cli/init/index.html). There are several ways to supply the remaining arguments:
    - **File:** A configuration file may be specified via the `init` command line. To specify a file, use the `backend-config=PATH` option when running `terraform init`. If the file contains secrets it may be kept in a secure data store, such as [Vault](https://www.vaultproject.io/), in which case it must be downloaded to the local disk before running Terraform.
    - **Command-line key/value pairs**: Key/value pairs can be specified via the `init` command line. Note that many shells retain command-line flags in a history file, so this isn't recommended for secrets. To specify a single key/value pair, use the `backend-config="KEY=VALUE"` option when running `terraform init`.
    - **Interactively**: Terraform will interactively ask you for the required values, unless interactive input is disabled. Terraform will not prompt for optional values.
- When using partial configuration, `Terraform requires at a minimum that an empty backend configuration` is specified in one of the root Terraform configuration files, to specify the backend type

```markdown
terraform {
  backend "consul" {}
}
```

- If you `no longer want to use any backend`, `you can simply remove the configuration from the file`. Terraform will detect this like any other change and prompt you to reinitialize. As part of the reinitialization, Terraform will ask if you'd like to migrate your state back down to normal local state. Once this is complete then Terraform is back to behaving as it does by default.
- `Terraform Cloud` always `encrypts state at rest and protects it with TLS in transit`. Terraform Cloud also knows the identity of the user requesting state and maintains a history of state changes. This can be used to control access and track activity. `Terraform Enterprise also supports detailed audit logging`.
- `The S3 backend supports encryption at rest when the encrypt option is enabled`. IAM policies and logging can be used to identify any invalid access. Requests for the state go over a TLS connection.
- Transport Layer Security (TLS) encrypts data sent over the Internet to ensure that eavesdroppers and hackers are unable to see what you transmit which is particularly useful for private and sensitive information such as passwords, credit card numbers, and personal correspondence.
- `Backends are completely optional`. You can successfully use Terraform without ever having to learn or use backends. `However, they do solve pain points that afflict teams at a certain scale`. If you're an individual, you can likely get away with never using backends.
- The benefits of Backends are:
    - `Working in a team`: Backends can store their state remotely and protect that state with locks to prevent corruption. Some backends such as Terraform Cloud even automatically store a history of all state revisions.
    - `Keeping sensitive information off disk`
    - `Remote operations`: For larger infrastructures or certain changes, terraform apply can take a long, long time. Some backends support remote operations which enable the operation to execute remotely. You can then turn off your computer and your operation will still complete. Paired with remote state storage and locking above, this also helps in team environments.
- Terraform has a `force-unlock` command to `manually unlock` the state if unlocking failed. . You should only use force unlock command `when automatic unlocking fails`. you have to add `force!!`

    - Assign variables in the configuration
        - **Command-line flags** `terraform apply -var 'region=us-east-1'`
        - **From a file**, create a file named `terraform.tfvars`
        - **From environment variables** `TF_VAR_name` ⇒ `TF_VAR_region`
        - **UI input,** Terraform will ask you to input the values interactively.
        - `If no value is assigned` to a variable via any of these methods and the variable has a `default key in its declaration, that value will be used for the variable`.

        ```markdown
        variable "region" {
          default = "us-east-1"
        }
        ```

- `Environment variables` can only populate `string-type variables`.
- **`Variable Definition Precedence`:** Terraform uses the *last* value it finds, overriding any previous values. Note that the same variable cannot be assigned multiple values within a single source. Terraform loads variables in the following order, with later sources taking precedence over earlier ones:
    - Environment variables
    - The `terraform.tfvars` file, if present.
    - The `terraform.tfvars.json` file, if present.
    - Any `.auto.tfvars` or `.auto.tfvars.json` files, processed in lexical order of their filenames.
    - Any `var` and `var-file` options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)Highest Priority!!
- Output variables: `Outputs are a way to tell Terraform what data is important`. This data is outputted when apply is called, and can be queried using the terraform output command.

```markdown
output "ip" {
  value = aws_eip.ip.public_ip
}
```

- Overuse of `dynamic blocks` can make configuration hard to read and maintain, so we recommend using them only when you need to hide details in order to build a clean user interface for a re-usable module. On the other hand, dynamic blocks help to manage the complex configurations
- `Terraform language does not support user-defined functions`
- `can` evaluates the given expression and returns a boolean value indicating whether the expression produced a result without any errors. The `can` function can only catch and handle dynamic errors resulting from access to data that isn't known until runtime.
- `try` is the built-in function to evaluates all of its argument expressions in turn and returns the result of the first one that does not produce any errors
- A resource spec addresses a specific resource in the config. It takes the form ⇒ `resource_type.resource_name[resource index]`
- `filebase64` reads the contents of a file at the given path and returns them as a base64-encoded string.

    ```markdown
    > filebase64("${path.module}/hello.txt")
    SGVsbG8gV29ybGQ=
    ```

- `formatdate` converts a timestamp into a different time format.

    ```markdown
    formatdate(spec, timestamp)
    ```

- `jsonencode` encodes a given value to a string using JSON syntax.

    ```markdown
    > jsonencode({"hello"="world"})
    {"hello":"world"}
    ```

- `cidrhost` calculates a full host IP address for a given host number within a given IP network address prefix.

    ```markdown
    > cidrhost("10.12.127.0/20", 16)
    10.12.112.16
    > cidrhost("10.12.127.0/20", 268)
    10.12.113.12
    > cidrhost("fd00:fd12:3456:7890:00a2::/72", 34)
    fd00:fd12:3456:7890::22
    ```

- `Sentinel` is an embedded policy-as-code framework integrated with the HashiCorp Enterprise products. It `enables fine-grained`, `logic-based policy decisions`, and `can be extended to use information from external sources`. One of the other benefits of `Sentinel` is that it also `has a full testing framework`.
- `Sentinel Policy` is applied before terraform apply and after terraform plan.
- `Sentinel` helps users to deploy configurations as policy as a code. Benefits are:

    ```markdown
    Sandboxing, automation, codification
    ```

- `Anyone` can `publish` and `share modules` on the `Terraform Registry`.
- `Terraform Cloud's private module registry` helps you share Terraform modules across your organization. It includes `support for module versioning`, `a searchable and filterable list of available modules`, and `a configuration designer to help you build new workspaces faster`.
- Using private module registry one can publish and create custom modules
- The list below contains all the requirements for publishing a module:
    - GitHub. The module must be on GitHub and must be a public repo.
    - Named terraform-<PROVIDER>-<NAME>. `terraform-aws-ec2-instance`
    - Repository description.
    - Standard module structure.
    - `x.y.z` tags for releases. ⇒ `v1.0.4` and `0.9.2`
- The difference between public and private module registries when defined source ⇒ public registry uses a there-part format, private moudules use a four-part format.
- Terraform Module Registry available at [`https://registry.terraform.io/`](https://registry.terraform.io/)
- `A workspace` contains everything Terraform needs to manage a given collection of infrastructure, and `separate workspaces function like completely separate working directories.`
- If you opt to use a workspace that already exists, the workspace must not have any existing states.
- If you are familiar with running Terraform using the CLI, you may have used Terraform workspaces. Terraform Cloud workspaces behave differently than Terraform CLI workspaces. Terraform CLI workspaces allow multiple state files to exist within a single directory, enabling you to use one configuration for multiple environments. Terraform Cloud workspaces contain everything needed to manage a given set of infrastructure, and function like separate working directories.
- By migrating your Terraform state, you can hand off infrastructure without de-provisioning anything.
- Workspaces, managed with the terraform workspace command, isn't the same thing as Terraform Cloud's workspaces. `Terraform Cloud workspaces act more like completely separate working directories`.
- `Version constraints` are supported only for modules installed from a module registry, such as the `public Terraform Registr`y or `Terraform Cloud's private module registry`
- Interacting with Vault from Terraform causes any secrets that you read and write to be persisted in both Terraform's state file and in any generated plan files. For any Terraform module that reads or writes Vault secrets, these files should be treated as sensitive and protected accordingly..
- `To authenticate the CLI with the terraform cloud`

    CLI and Api interactions usually requires API tokens to be generated to access the terraform cloud

    ```markdown
    1. terraform login
    2. it will open the terraform cloud and generate the token
    3. paste that token back in the CLI
    ```

- You are building infrastructure on your local machine and you changed your backend to remote backend with the Terraform cloud. `What should you do to migrate the state to the remote backend?`
    - Once you have authenticated the remote backend, you're ready to migrate your local state file to Terraform Cloud. To begin the migration, reinitialize. This causes Terraform to recognize your changed backend configuration.

```markdown
$ terraform init

Initializing the backend...
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "remote" backend. No existing state was found in the newly
  configured "remote" backend. Do you want to copy this state to the new "remote"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value:
```

- During reinitialization, Terraform presents a prompt saying that it will copy the state file to the new backend. Enter yes and Terraform will migrate the state from your local machine to Terraform Cloud.
- `Initiate a run in the new workspace` After verifying that the state was migrated to the Terraform Cloud workspace, remove the local state file. `rm terraform.tfstate` Apply a new run. `terraform apply`
- `To configure remote backend with the terraform cloud` You need to configure in the terraform block

    ```markdown
    terraform {
      backend "remote" {
        hostname      = "app.terraform.io"
        organization  = "<YOUR-ORG-NAME>"

        workspaces {
          name = "state-migration"
        }
      }
    }
    ```

- `Run Triggers` Terraform Cloud’s run triggers allow you to link workspaces so that a successful apply in a source workspace will queue a run in the workspace linked to it with a run trigger. `For example, adding new subnets to your network configuration could trigger an update to your application configuration to rebalance servers across the new subnets.`
- `The benefit of Run Triggers` When managing complex infrastructure with Terraform Cloud, organizing your configuration into different workspaces helps you to better manage and design your infrastructure and ⇒ Configuring run triggers between workspaces allows you to set up infrastructure pipelines as part of your overall deployment strategy.
- Terraform Cloud teams can have `read, plan, write, or admin permissions on individual workspaces`
- The format of resource block configurations is as follows:

`<block type> "<resource type>" "<local name/label>"`

- The `terraform validate` command validates the configuration files in a directory, referring only to the configuration and not accessing any remote services such as remote state, provider APIs, etc.
    - Validate runs checks that verify whether a configuration is syntactically valid and internally consistent, regardless of any provided variables or existing state. It is thus primarily useful for general verification of reusable modules, including correctness of attribute names and value types.

- The terraform plan command is used to create an execution plan. Terraform performs a refresh, unless explicitly disabled, and then determines what actions are necessary to achieve the desired state specified in the configuration files. This command is a convenient way to check whether the execution plan for a set of changes matches your expectations without making any changes to real resources or to the state.

- `Organization owners grant permissions` by grouping users into teams and giving those teams priviliges based on their need for access to individual workspaces.
- The plan you need to `manage teams` on Terraform cloud is `Team Plan`
- `add users to an organization` You can add users to an organization by inviting them using their email address. Even if your team member has not signed up for Terraform Cloud yet, they can still accept the invitation and create a new account.
- The `Terraform Cloud Team` plan is `charged` on a per-user basis so `adding new users to your organization incurs cost`.
- Which flag is used to find more information about a Terraform command? For example, you need additional information about how to use the plan command. You would type: terraform plan `-h or -help or --help`. Type your answer in the field provided. The text field is not case-sensitive and all variations of the correct answer are accepted.
- `To change instance type without changing default set values` Modify the `terraform.tfvars` with the instance type ⇒ terraform plan and then terraform apply to deploy the instances
- `Use Sensitive Parameter` make sure password are not outputted. But if you have access permission to see state files you can see there in plain-text format.
- `supported OS to deploy Terraform` Windows, Amazon Linux, freeBSD, Unix, MacOS
- to enable details logs to find all the details `. TF_LOG` then you can set to TRACE, INFO, WARN or ERROR, DEBUG Levels.
- After doing changes on tfvar files you can see the content of the state file with the `Terraform show` command.
- You should NOT include `terraform.tfstate` file (sensitive information) during git commit.
- Before migrating existing infrastructure you should make sure resources of the existing infrastructure are updated in the configuration file. Because terraform supports imports of a resource into state file not with configuration file. Therefore, we need to first add the resource configuration then use `terraform import`.
- `input variable` make terraform code more dynamic. When you apply input
- `terraform force-unlock` with this command you can manually remove the lock.
- after apply `terraform init` plugin related files or configurations saved under `.terraform/plugins`
- `TF_VAR` for debugging environment variables.
- Terraform `console` command is used to evaluate expressions in terraform .
- `MySQL` has its` own provider.
- to run unassociated provisioners use `“_”:null-resource`
- Terraform configuration supports `json` language.
- use `alias` for same provider - different resources.
- Terraform supports `consul, gcs, manta` backend types.  Consul helps locking state file for remote backend.
- Resource should have unique names.
- You can `import manually` created `VM` on azure.
- `sensitive flag` prevents to be seen passwords in plain text in `logs` but like mentioned before if you have access to state files output you can see there.
- if you remove an AWS instance from the state, the instance will continue running.
- There is `no requirement that current and desired state should be in same state` all the time.
- `terraform init` whenever you add a new provider, you should apply terraform init.
- You can dynamically construct repeatable nested blocks like setting using a special dynamic block type, which is supported inside resource, data, provider, and provisioner blocks: `prevents long code and more manageable`

    ```markdown
    resource "aws_elastic_beanstalk_environment" "tfenvtest" {
      name                = "tf-test-name"
      application         = "${aws_elastic_beanstalk_application.tftest.name}"
      solution_stack_name = "64bit Amazon Linux 2018.03 v2.11.4 running Go 1.12.6"

      dynamic "setting" {
        for_each = var.settings
        content {
          namespace = setting.value["namespace"]
          name = setting.value["name"]
          value = setting.value["value"]
        }
      }
    }
    ```

- A `dynamic block` acts much like a for `expression`, but produces nested blocks instead of a complex typed value. `It iterates over a given complex value, and generates a nested block for each element of that complex value`.
- Using terraform iterator we can set name to a temporary variable that matches to an element
- In Production Environment it is always recommended to hardcode the provider version.
- `Mongodb Atlas` is a supported database provider approved by hashicorp.
- We can not create `duplicate resources` we will get the `The resource already exists` error message.
- `lookup` retrieves the value of a single element from a map, given its key. If the given key does not exist, the given default value is returned instead.

    ```markdown
    > lookup({a="ay", b="bee"}, "a", "what?")
    ay
    > lookup({a="ay", b="bee"}, "c", "what?")
    what?
    ```

- `Consul` is used for service discovery and configuration, and helps to expose resources to be used to interact with consul cluster.
- `Consul` is a service networking platform which provides service discovery, service mesh, and application configuration capabilities. The `Consul provider` exposes resources used to interact with a Consul cluster. Configuration of the provider is optional, as it provides reasonable defaults for all arguments.
    - **NOTE:**

    The `Consul provider` should not be confused with the [`Consul remote state backend`](https://www.terraform.io/docs/backends/types/consul.html), which is one of many backends that can be used to store Terraform state. The Consul provider is instead used to manage resources within Consul itself, such as adding external services or working with the key/value store.

- `terraform console` command provides an interactive console for evaluating [expressions](https://www.terraform.io/docs/language/expressions/index.html). This command provides an interactive command-line console for evaluating and experimenting with expressions. This is useful for testing interpolations before using them in configurations, and for interacting with any values currently saved in state.
- The `terraform console` command can be used in non-interactive scripts by piping newline-separated commands to it. Only the output from the final command is printed unless an error occurs earlier.

    For example:

    ```markdown
    $ echo "1 + 5" | terraform console
    6
    ```

- The `Vault provider` allows Terraform to read from, write to, and configure HashiCorp Vault. `HCP Vault` provides all of the power and security of Vault, without the complexity and overhead of managing it yourself. Access Vault’s best-in-class secrets management and encryption capabilities instantly and onboard applications and teams easily. If you are using a vault provider you will get the data during `terraform plan`
- `terraform plan` will only show what is configured but not anything manually configured.
- `Terraform Cloud` and `Terraform Enterprise` are different distributions of the same application;
- [Terraform Cloud](https://terraform.io/cloud) is an application that helps teams use Terraform together. It manages Terraform runs in a consistent and reliable environment, and includes easy access to shared state and secret data, access controls for approving changes to infrastructure, a private registry for sharing Terraform modules, detailed policy controls for governing the contents of Terraform configurations, and more.
- Terraform cloud private registry is not a paid feature.
- Terraform Cloud is available as a hosted service at [https://app.terraform.io](https://app.terraform.io/). Small teams can sign up for free to connect Terraform to version control, share variables, run Terraform in a stable remote environment, and securely store remote state. Paid tiers allow you to add more than five users, create teams with different levels of permissions, enforce policies before creating infrastructure, and collaborate more effectively.
- The [Business tier](https://www.hashicorp.com/products/terraform/editions/cloud) allows large organizations to scale to multiple concurrent runs, create infrastructure in private environments, manage user access with SSO, and automates self-service provisioning for infrastructure end users.
- Enterprises with advanced security and compliance needs can purchase [Terraform Enterprise](https://www.terraform.io/docs/enterprise/index.html), our self-hosted distribution of Terraform Cloud. It offers enterprises a private instance that includes the advanced features available in Terraform Cloud.
- `Terraform Enterprise` is our self-hosted distribution of Terraform Cloud. It offers enterprises a private instance of the Terraform Cloud application, with no resource limits and with additional enterprise-grade architectural features like audit logging and SAML single sign-on. `Ubuntu 16.0.4.3` `Centos – 7.7` supports terraform enterprise version. (Saml/sso, Audit logginng, Servicenow integration)
- For local state, Terraform stores the `workspace` states in a directory called `terraform.tfstate.d`. This directory should be treated similarly to local-only terraform.tfstate; some teams commit these files to version control, although using a remote backend instead is recommended when there are multiple collaborators.
- The `"current workspace"` name is stored only locally in the ignored `.terraform` directory.
- Terraform Cloud supports the following VCS providers:
- [GitHub.com](https://www.terraform.io/docs/cloud/vcs/github-app.html)
- [GitHub.com (OAuth)](https://www.terraform.io/docs/cloud/vcs/github.html)
- [GitHub Enterprise](https://www.terraform.io/docs/cloud/vcs/github-enterprise.html)
- [GitLab.com](https://www.terraform.io/docs/cloud/vcs/gitlab-com.html)
- [GitLab EE and CE](https://www.terraform.io/docs/cloud/vcs/gitlab-eece.html)
- [Bitbucket Cloud](https://www.terraform.io/docs/cloud/vcs/bitbucket-cloud.html)
- [Bitbucket Server](https://www.terraform.io/docs/cloud/vcs/bitbucket-server.html)
- [Azure DevOps Server](https://www.terraform.io/docs/cloud/vcs/azure-devops-server.html)
- [Azure DevOps Services](https://www.terraform.io/docs/cloud/vcs/azure-devops-services.html)
-
- `Self-Service Infrastructure`, `Audit Logging`, and `SAML/SSO` are only available in Terraform Cloud for Business or Terraform Enterprise.
- Terraform destroy will always prompt for confirmation before executing unless passed the -auto-approve flag.
- When assigning a value to an argument, it must be enclosed in quotes ("...") unless it is being generated programmatically.
- Terraform is an immutable, declarative, infrastructure as code provisioning language based on HCL or optionally JSON
- The `terraform state` command is used for advanced state management. Rather than modify the state directly, the `terraform state` commands can be used in many cases instead. To refresh Terraform state, use the command terraform refresh.
- Terraform can limit the number of concurrent operations as Terraform walks the graph using the -parallelism=n argument. The default value for this setting is 10. This setting might be helpful if you're running into API rate limits.
- The `terraform refresh` command is used to reconcile the state Terraform knows about (via its state file) with the real-world infrastructure. This can be used to detect any drift from the last-known state, and to update the state file. **This does not modify infrastructure but *does* modify the state file.** If the state is changed, this may cause changes to occur during the next plan or apply.
- Currently, Terraform has no mechanism to redact or protect secrets that are returned via data sources, so secrets read via this provider will be persisted into the Terraform state, into any plan files, and in some cases in the console output produced while planning and applying. These artifacts must, therefore, all be protected accordingly.
- list(...): a sequence of values identified by consecutive whole numbers starting with zero.
- map(...): a collection of values where each is identified by a string label.
- set(...): a collection of unique values that do not have any secondary identifiers or ordering.
- It is important to consider that `Terraform reads from data sources during the plan phase` and writes the result into the plan. For something like a Vault token which has an explicit TTL, the apply must be run before the data, or token, in this case, expires, otherwise, Terraform will fail during the apply phase.
- Terraform analyzes any expressions within a resource block to find references to other objects and treats those references as implicit ordering requirements when creating, updating, or destroying resources.
- `Postgresql` is the backend type used by `terraform enterprise` to work
- `~` `Tilde` symbol means resources will be updated.
- Terraform provider is not a plugin!! Terraform provider is for API interactions and resources like AWS, GCP...
- A single workspace can only be configured to a single vcs, but `multiple workspaces can use same repo`
- Infrastructure as Code has many benefits, including being able to create a blueprint of your data center which can be versioned, shared, and reused. However, in a general sense, not all IaC tools are platform agnostic like Terraform.

```
module "vpc" {
  source = "git::https://example.com/vpc.git?ref=v1.2.0"
}
```

- HashiCorp style conventions suggest you that align the equals sign for consecutive arguments for easing readability for configurations

```
ami           = "abc123"
instance_type = "t2.micro"
```

- Use empty lines to separate logical groups of arguments within a block.
- The terraform import command is used to import existing resources into Terraform. This allows you to take resources that you’ve created by some other means and bring them under Terraform management.

References:

[kodekloud](https://kodekloud.com/)

[250-practice-questions](https://medium.com/bb-tutorials-and-thoughts/250-practice-questions-for-terraform-associate-certification-7a3ccebe6a1a)

[terraform.io](https://www.terraform.io/docs/index.html)

[udemy-practice-exam/](https://www.udemy.com/course/terraform-associate-practice-exam/)

[Terraform Cheatsheet](https://justinoconnorcodes.files.wordpress.com/2021/09/terraform-cheatsheet-1.pdf)


## ****
[1](https://www.udemy.com/course/hashicorp-certified-terraform-associate-2020/)
[2](https://www.udemy.com/course/terraform-associate-certification-2021-practice-exams/)