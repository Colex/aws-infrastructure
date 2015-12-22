variable "region" { default = "eu-west-1" }
variable "id"     { default = 0 }

# ECS Configuration
variable "ecs_cluster_name"   { default = "services" }
variable "ecs_cluster_size"   { default = 5 }
variable "ecs_ami"            { default = "ami-8073d3f3" }
variable "ecs_instance_type"  { default = "m3.medium" }
variable "ecs_key"            { default = "ecs-services" }
variable "ecs_profile_id"     {}

# Bastion Configuration
variable "bastion_ami"            { default = "ami-9d2f0fea" }
variable "bastion_instance_type"  { default = "t2.small" }
variable "bastion_key"            { default = "bastion" }

variable "zones" {
  default = "a,b,c"
}

variable "cidr_blocks_public" {
  default = {
    zone0 = "10.0.0.0/21"
    zone1 = "10.0.8.0/21"
    zone2 = "10.0.16.0/21"
    zone3 = "10.0.24.0/21"
  }
}

variable "cidr_blocks_private" {
  default = {
    zone0 = "10.0.32.0/21"
    zone1 = "10.0.40.0/21"
    zone2 = "10.0.48.0/21"
    zone3 = "10.0.56.0/21"
  }
}

variable "cidr_blocks_storage" {
  default = {
    zone0 = "10.0.64.0/21"
    zone1 = "10.0.72.0/21"
    zone2 = "10.0.80.0/21"
    zone3 = "10.0.88.0/21"
  }
}
