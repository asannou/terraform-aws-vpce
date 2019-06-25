variable "vpc_id" {}

variable "service" {}

variable "subnet_ids" {
  type = "list"
}

data "aws_region" "region" {}

data "aws_vpc" "vpc" {
  id = "${var.vpc_id}"
}

data "aws_route_tables" "gateway" {
  filter {
    name = "association.subnet-id"
    values = ["${var.subnet_ids}"]
  }
}

resource "aws_vpc_endpoint" "gateway" {
  vpc_id = "${data.aws_vpc.vpc.id}"
  service_name = "com.amazonaws.${data.aws_region.region.name}.${var.service}"
  route_table_ids = ["${data.aws_route_tables.gateway.ids}"]
  tags = {
    Name = "${var.service}"
  }
}
