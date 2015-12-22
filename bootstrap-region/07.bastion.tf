resource "aws_instance" "bastion" {
  count           = 3
  ami             = "${var.bastion_ami}"
  instance_type   = "${var.bastion_instance_type}"
  subnet_id       = "${element(aws_subnet.public.*.id, count.index)}"
  key_name        = "${var.bastion_key}"
  security_groups = ["${aws_security_group.bastion.id}"]
  tags {
      Name = "Bastion"
  }
}
