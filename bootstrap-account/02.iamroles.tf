resource "aws_iam_instance_profile" "ecs_profile" {
    name  = "${var.ecs_profile_name}"
    roles = ["${aws_iam_role.ecs_role.name}"]
}

resource "aws_iam_role_policy" "ecs_policy" {
    name    = "${var.ecs_policy_name}"
    role    = "${aws_iam_role.ecs_role.id}"
    policy  = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*"
      ],
      "Resource": "*"
    }
  ]
}
EOT
}

resource "aws_iam_role" "ecs_role" {
    name                = "${var.ecs_role_name}"
    assume_role_policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
