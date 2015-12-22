resource "aws_eip" "nat_gateway" {
  count = "${length(split(",", var.zones))}"
  vpc   = true
}

resource "aws_nat_gateway" "private" {
  count         = "${length(split(",", var.zones))}"
  allocation_id = "${element(aws_eip.nat_gateway.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
}

resource "aws_route_table" "private" {
  count         = "${length(split(",", var.zones))}"
  vpc_id        = "${aws_vpc.main.id}"
  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = "${element(aws_nat_gateway.private.*.id, count.index)}"
  }
  tags {
    Name = "private"
  }
}

resource "aws_route_table_association" "private_association" {
  count           = "${length(split(",", var.zones))}"
  subnet_id       = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id  = "${element(aws_route_table.private.*.id, count.index)}"
}
