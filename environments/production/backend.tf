terraform {
  backend "s3" {
    bucket         = "motortech-tf-state"
    key            = "infra-db/production/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "motortech-tf-lock"
    encrypt        = true
  }
}
