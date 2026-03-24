# Database Credentials
resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "${var.project}/db-credentials-${var.environment}"
  description = "Credenciais do banco de dados RDS MySQL"

  tags = {
    Name        = "${var.project}-db-credentials"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    host     = var.db_host
    port     = var.db_port
    dbname   = var.db_name
    username = var.db_username
    password = var.db_password
  })
}

# JWT Secret (shared between Lambda and Laravel)
resource "aws_secretsmanager_secret" "jwt_secret" {
  name        = "${var.project}/jwt-secret-${var.environment}"
  description = "JWT Secret compartilhado entre Lambda e Laravel"

  tags = {
    Name        = "${var.project}-jwt-secret"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "jwt_secret" {
  secret_id     = aws_secretsmanager_secret.jwt_secret.id
  secret_string = var.jwt_secret
}

# Laravel APP_KEY
resource "aws_secretsmanager_secret" "app_key" {
  name        = "${var.project}/app-key-${var.environment}"
  description = "Laravel APP_KEY"

  tags = {
    Name        = "${var.project}-app-key"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "app_key" {
  secret_id     = aws_secretsmanager_secret.app_key.id
  secret_string = var.app_key
}

# Webhook Token
resource "aws_secretsmanager_secret" "webhook_token" {
  name        = "${var.project}/webhook-token-${var.environment}"
  description = "Token para autenticação de webhooks"

  tags = {
    Name        = "${var.project}-webhook-token"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "webhook_token" {
  secret_id     = aws_secretsmanager_secret.webhook_token.id
  secret_string = var.webhook_token
}
