# AWS Infrastructure Boilerplate

This boilerplate will use [Terraform](https://github.com/hashicorp/terraform) to generate a base infrastructure which can be used in most projects that look for security and high availability. It will create a **VPC** in one or more regions and subnets with **3 isolation levels** across all or a chosen set of availability zones. It will also take care of creating an **Internet Gateway** and a **NAT gateway** in each availability zone. The **Isolation layers** created are:

- **Public:** Communication can be initiated from the internet. By default, only ports 80 and 443 will be visible and servers will get a public IP. *This layer is meant to be used by load balancers*.
- **Private w/ Internet Access:** Communication **cannot** be initiated from the internet, but the internet is accessible from inside (therefore all AWS is available). It is accessible by the **public layer**, so it's a good candidate layer for web services.
- **Private:** Communication **cannot** be initiated from the internet or to the internet. Its level of isolation may be ideal for storage.

Since access to the private instances is limited to traffic with the VPC, it will also take care of creating **bastion hosts** for accessing instances within the VPC.

Finally, it will create an **ECS cluster** for deploying web services (you can easily configure it not to if wanted).

## Requirements
The only software requirement is ``terraform v0.6.9``.

You also need an AWS account and keys with privileges for managing resources, policies and roles.

## Running
Running ``terraform`` is very simples. Start by setting up the environment variables ``AWS_ACCESS_KEY_ID`` and ``AWS_SECRET_ACCESS_KEY``, then load the modules and apply the changes:
```
terraform get
terraform apply
```

You can see all changes that will be made before actually applying by looking at the plan:
```
terraform plan --module-depth=1
```

## Configuration
The configuration file comes with an example of a configuration that sets up the infrastructure across two different regions. The file ``./configuration.tf`` holds all the settings:
```HCL
# Account bootstrap will set up all resources
# shared by all regions (roles, policies...)
module "account" {
  source = "./bootstrap-account"
}

module "eu-west-1" {
  source = "./bootstrap-region"
  id = 0
  region = "eu-west-1"
  zones = "a,b,c"
  ecs_profile_id = "${module.account.ecs_profile_id}"
}

module "us-east-1" {
  source = "./bootstrap-region"
  id = 1
  region = "us-east-1"
  zones = "b,c,d,e"
  bastion_key = "bastion"
  bastion_ami = "ami-60b6c60a"
  ecs_ami = "ami-6ff4bd05"
  ecs_key = "ecs-services"
  ecs_profile_id = "${module.account.ecs_profile_id}"
}
```

You must configure the **environment variables** ``AWS_ACCESS_KEY_ID`` and ``AWS_SECRET_ACCESS_KEY`` for it to work.

### Configuring Region
This is the template for configuring a region:
```HCL
module "[REGION_NAME]" {
  source = "./bootstrap-region"
  id = [UNIQUE_ID: 0-255]                             # Mandatory
  region = "[REGION_NAME]"                            # Mandatory
  zones = "[LIST_OF_AVAILABILITY_ZONES]"              # Mandatory
  bastion_key = "[KEY_PAIR_NAME]"                     # Optional
  bastion_ami = "[AMI_FOR_BASTION]"                   # Optional
  bastion_instance_type = "[INSTANCE_TYPE]"           # Optional
  ecs_cluster_size = [NUMBER_OF_INSTANCES]            # Optional
  ecs_ami = "[AMI_FOR_ECS]"                           # Optional
  ecs_key = "[KEY_PAIR_NAME]"                         # Optional
  ecs_instance_type = "[INSTANCE_TYPE]"               # Optional
  ecs_profile_id = "${module.account.ecs_profile_id}" # Mandatory
}
```
*(For more information, read the file ``./bootstrap-region/main.tf``)*

## Structure
The project is split into two modules ``bootstrap-account`` and ``bootstrap-region``. The first (``bootstrap-account``) is responsible for all resources that will be shared across different regions *(usually roles, profiles and policies)*.

Within each module, the entry point and definition of input variables are in the file ``main.tf``. Resources are split into self-explanatory files (e.g. bastion hosts are defined within ``07.bastion.tf``).

Changes and updates are encouraged, especially improvements around security.
