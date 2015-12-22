resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Allow SSH traffic from outside of VPC"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "public" {
  name        = "public"
  description = "Allow access to HTTP and HTTPS ports from anywhere"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private" {
  name        = "private"
  description = "Allow any access from the public network and SSH from bastion"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      security_groups = ["${aws_security_group.public.id}"]
  }

  ingress {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      self      = true
  }

  ingress {
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      security_groups = ["${aws_security_group.bastion.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "storage" {
  name        = "storage"
  description = "Allow any access from the private network"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      security_groups = ["${aws_security_group.private.id}"]
  }

  ingress {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
