resource "aws_subnet" "public" {
  count                   = "${length(split(",", var.zones))}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${element(template_file.cidr_blocks.*.rendered, count.index)}"
  availability_zone       = "${concat(var.region, element(split(",", var.zones), count.index))}"
  map_public_ip_on_launch = true
  tags {
    Name = "public"
  }
}

resource "aws_subnet" "private" {
  count                   = "${length(split(",", var.zones))}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${element(template_file.cidr_blocks.*.rendered, count.index + length(split(",", var.zones)))}"
  availability_zone       = "${concat(var.region, element(split(",", var.zones), count.index))}"
  map_public_ip_on_launch = false
  tags {
    Name = "private"
  }
}

resource "aws_subnet" "storage" {
  count                   = "${length(split(",", var.zones))}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${element(template_file.cidr_blocks.*.rendered, count.index + (length(split(",", var.zones)) * 2))}"
  availability_zone       = "${concat(var.region, element(split(",", var.zones), count.index))}"
  map_public_ip_on_launch = false
  tags {
    Name = "storage"
  }
}
