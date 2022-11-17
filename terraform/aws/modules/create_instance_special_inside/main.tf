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

resource "aws_instance" "default" {
  for_each = local.data

  ami = data.aws_ami.image[each.key].id

  cpu_core_count       = each.value.cpu_count
  cpu_threads_per_core = each.value.cpu_threads_per_core

  root_block_device {
    volume_size = each.value.size
    volume_type = var.disk_type
  }

  instance_type   = each.value.type
  private_ip      = each.value.ip_v4
  subnet_id       = data.aws_subnet.default.id
  security_groups = ["${var.security_groups}"]
  associate_public_ip_address = false
  
  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name = each.value.name
  }
}
