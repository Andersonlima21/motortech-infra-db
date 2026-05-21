terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "motortech"
      Environment = "homologation"
      ManagedBy   = "terraform"
    }
  }
}

# Buscar dados do VPC criado pelo repo infra-k8s
data "aws_vpc" "main" {
  tags = {
    Name = "motortech-vpc"
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  tags = {
    Name = "motortech-private-*"
  }
}

module "rds" {
  source = "../../modules/rds"

  project     = var.project
  environment = "homologation"
  vpc_id      = data.aws_vpc.main.id
  private_subnet_ids = data.aws_subnets.private.ids

  instance_class        = "db.t3.micro"
  multi_az              = false
  skip_final_snapshot   = true
  deletion_protection   = false
  db_password           = var.db_password
}

module "secrets" {
  source = "../../modules/secrets-manager"

  project     = var.project
  environment = "homologation"
  db_host     = module.rds.address
  db_port     = module.rds.port
  db_name     = module.rds.db_name
  db_username = "motortech"
  db_password = var.db_password
  jwt_secret  = var.jwt_secret
  app_key     = var.app_key
  webhook_token = var.webhook_token
}
