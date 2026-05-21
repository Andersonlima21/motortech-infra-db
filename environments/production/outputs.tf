output "rds_endpoint" {
  value = module.rds.endpoint
}

output "rds_address" {
  value = module.rds.address
}

output "rds_port" {
  value = module.rds.port
}

output "db_credentials_secret_arn" {
  value = module.secrets.db_credentials_arn
}

output "jwt_secret_arn" {
  value = module.secrets.jwt_secret_arn
}
