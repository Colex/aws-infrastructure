variable "ecs_role_name"    { default = "ecs-role" }
variable "ecs_profile_name" { default = "ecs-profile" }
variable "ecs_policy_name"  { default = "ecs-policy" }

output "ecs_profile_id" {
  value = "${aws_iam_instance_profile.ecs_profile.id}"
}
