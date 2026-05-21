variable "project" {
  type    = string
  default = "motortech"
}

variable "environment" {
  type = string
}

variable "db_host" {
  type = string
}

variable "db_port" {
  type    = number
  default = 3306
}

variable "db_name" {
  type    = string
  default = "motortech"
}

variable "db_username" {
  type = string
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
