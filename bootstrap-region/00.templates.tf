resource "template_file" "main_vpc_cidr" {
  template = "10.${id}.0.0/16"
  vars {
    id = "${var.id}"
  }
}

resource "template_file" "cidr_blocks" {
  count = "${length(split(",", var.zones)) * 3}"
  template = "10.${id}.${az}.0/21"
  vars {
    id = "${var.id}"
    az = "${count.index*8}"
  }
}
