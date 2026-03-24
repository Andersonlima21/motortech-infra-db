variable "project" {
  type    = string
  default = "motortech"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "jwt_secret" {
  type      = string
  sensitive = true
}

variable "app_key" {
  type      = string
  sensitive = true
}

variable "webhook_token" {
  type      = string
  sensitive = true
}
