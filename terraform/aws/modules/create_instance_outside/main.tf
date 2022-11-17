terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

locals {
  json_data = jsondecode(file("${var.dataPath}"))
  data      = { for k, v in local.json_data : k => v }
}

data "aws_vpc" "default" {
  id         = var.vpcid
  cidr_block = var.vpc_cidr
}

data "aws_subnet" "default" {
  vpc_id     = data.aws_vpc.default.id
  cidr_block = var.subnet_cidr
}

data "aws_ami" "image" {
  for_each = local.data

  most_recent = true

  owners = ["${var.owners}"]

  filter {
    name   = "name"
    values = ["${each.value.ami_name}"]
  }
}

resource "aws_security_group" "default" {
  for_each = local.data

  name        = each.value.name
  description = each.value.secutiry_group.description
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

resource "aws_instance" "default" {
  for_each = local.data

  ami = data.aws_ami.image[each.key].id

  root_block_device {
    volume_size = each.value.size
    volume_type = var.disk_type
  }

  instance_type   = each.value.type
  private_ip      = each.value.ip_v4
  subnet_id       = data.aws_subnet.default.id
  security_groups = ["${aws_security_group.default[each.key].id}"]

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name = each.value.name
  }
}

resource "aws_eip" "default" {
  for_each = local.data

  instance = aws_instance.default[each.key].id
  vpc      = true

  tags = {
    Name = "${each.value.name}-public"
  }
}

resource "aws_eip_association" "eip_assoc" {
  for_each = local.data

  instance_id   = aws_instance.default[each.key].id
  allocation_id = aws_eip.default[each.key].id
}