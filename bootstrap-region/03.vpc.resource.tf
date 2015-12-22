resource "aws_vpc" "main" {
    cidr_block = "${template_file.main_vpc_cidr.rendered}"
    tags {
      Name = "main"
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = "${aws_vpc.main.id}"
    tags {
        Name = "Main Internet Gateway"
    }
}

resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.main.id}"
  }
  tags {
      Name = "main"
  }
}

resource "aws_main_route_table_association" "main" {
    vpc_id          = "${aws_vpc.main.id}"
    route_table_id  = "${aws_route_table.main.id}"
}
