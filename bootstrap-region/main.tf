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
