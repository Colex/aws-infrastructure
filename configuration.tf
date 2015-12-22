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
