provider "aws" {
  region = "ap-northeast-2"
}

provider "aws" {
  region = "ap-northeast-3"
  alias  = "osaka"
}

module "copy_ami" {
  source            = "./modules/copy_ami"
  filter_field      = "availability-zone"
  filter_value      = "ap-northeast-2a"
  source_ami_region = "ap-northeast-2"
}

module "create_instance_inside" {
  source = "./modules/create_instance_inside"

  providers = {
    aws = aws.osaka
  }

  dataPath        = "inside.json"
  vpc_cidr        = "10.9.0.0/16"
  vpcid           = "vpc-0be2a66cbd0109391"
  subnet_cidr     = "10.9.24.0/24"
  disk_type       = "gp3"
  security_groups = "sg-0565aa6e33b6275aa"
  owners          = "000000000000"

  depends_on = [
    module.copy_ami
  ]
}

module "create_instance_special_inside" {
  source = "./modules/create_instance_special_inside"

  providers = {
    aws = aws.osaka
  }

  dataPath        = "special_inside.json"
  vpc_cidr        = "10.9.0.0/16"
  vpcid           = "vpc-0be2a66cbd0109391"
  subnet_cidr     = "10.9.24.0/24"
  disk_type       = "gp3"
  security_groups = "sg-0565aa6e33b6275aa"
  owners          = "000000000000"

  depends_on = [
    module.copy_ami
  ]
}

module "create_instance_outside" {
  source = "./modules/create_instance_outside"

  providers = {
    aws = aws.osaka
  }

  dataPath    = "outside.json"
  vpc_cidr    = "10.9.0.0/16"
  vpcid       = "vpc-0be2a66cbd0109391"
  subnet_cidr = "10.9.22.0/24"
  disk_type   = "gp3"
  owners      = "000000000000"

  depends_on = [
    module.copy_ami
  ]
}


