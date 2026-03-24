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
      Environment = "production"
      ManagedBy   = "terraform"
    }
  }
}

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
  environment = "production"
  vpc_id      = data.aws_vpc.main.id
  private_subnet_ids = data.aws_subnets.private.ids

  instance_class        = "db.t3.small"
  multi_az              = true
  skip_final_snapshot   = false
  deletion_protection   = true
  backup_retention_period = 14
  db_password           = var.db_password
}

module "secrets" {
  source = "../../modules/secrets-manager"

  project     = var.project
  environment = "production"
  db_host     = module.rds.address
  db_port     = module.rds.port
  db_name     = module.rds.db_name
  db_username = "motortech"
  db_password = var.db_password
  jwt_secret  = var.jwt_secret
  app_key     = var.app_key
  webhook_token = var.webhook_token
}
