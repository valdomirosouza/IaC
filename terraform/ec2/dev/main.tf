
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.10"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "ec2_server_dev" {
  source = "../modules/ec2-instance"

  # Variáveis
  aws_region         = var.aws_region
  vpc_id             = var.vpc_id
  security_group_id  = var.security_group_id
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  key_pair_name      = var.key_pair_name
  name               = var.name
  environment        = var.environment
  root_volume_size   = var.root_volume_size
  root_volume_type   = var.root_volume_type
  root_volume_encrypted = var.root_volume_encrypted
  root_data_volume_delete_on_termination = var.root_data_volume_delete_on_termination
}
