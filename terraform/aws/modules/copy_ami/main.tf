terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-northeast-3"
  alias  = "osaka"
}

data "aws_instances" "default" {
  instance_state_names = ["running"]

  filter {
    name   = var.filter_field
    values = [var.filter_value]
  }
}

data "aws_instance" "default" {
  for_each = toset(data.aws_instances.default.ids)

  instance_id = each.value
}

resource "aws_ami_from_instance" "default" {
  for_each = data.aws_instance.default

  name                    = each.value.tags["Name"]
  source_instance_id      = each.value.instance_id
  snapshot_without_reboot = true

  tags = {
    Name = "terraform-${each.value.tags["Name"]}"
  }
}

resource "aws_ami_copy" "default" {
  provider = aws.osaka
  for_each = aws_ami_from_instance.default

  name              = each.value.tags["Name"]
  source_ami_id     = each.value.id
  source_ami_region = var.source_ami_region

  tags = {
    Name = each.value.tags["Name"]
  }

  timeouts {
    create = "120m"
  }

  depends_on = [aws_ami_from_instance.default]
}
