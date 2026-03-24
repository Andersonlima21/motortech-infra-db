output "db_credentials_arn" {
  value = aws_secretsmanager_secret.db_credentials.arn
}

output "jwt_secret_arn" {
  value = aws_secretsmanager_secret.jwt_secret.arn
}

output "app_key_arn" {
  value = aws_secretsmanager_secret.app_key.arn
}

output "webhook_token_arn" {
  value = aws_secretsmanager_secret.webhook_token.arn
}
