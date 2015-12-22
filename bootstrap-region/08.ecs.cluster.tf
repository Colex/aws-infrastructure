resource "aws_ecs_cluster" "services" {
  name = "${var.ecs_cluster_name}"
}

resource "aws_instance" "service" {
  count                 = "${var.ecs_cluster_size}"
  ami                   = "${var.ecs_ami}"
  key_name              = "${var.ecs_key}"
  instance_type         = "${var.ecs_instance_type}"
  subnet_id             = "${element(aws_subnet.private.*.id, count.index % length(split(",", var.zones)))}"
  security_groups       = ["${aws_security_group.private.id}"]
  iam_instance_profile  = "${var.ecs_profile_id}"
  user_data             = <<EOT
#!/bin/bash
echo ECS_CLUSTER=services >> /etc/ecs/ecs.config
EOT
  tags {
      Name = "${var.ecs_cluster_name} ecs"
  }
}
