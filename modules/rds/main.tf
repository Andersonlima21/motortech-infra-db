resource "aws_db_subnet_group" "main" {
  name       = "${var.project}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.project}-db-subnet-group"
    Environment = var.environment
  }
}

resource "aws_security_group" "rds" {
  name_prefix = "${var.project}-rds-"
  vpc_id      = var.vpc_id
  description = "Security group for RDS MySQL"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_group_ids = var.allowed_security_group_ids
    description     = "Allow MySQL from EKS and Lambda"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name = "${var.project}-rds-sg"
  }
}

resource "aws_db_instance" "main" {
  identifier     = "${var.project}-db-${var.environment}"
  engine         = "mysql"
  engine_version = "8.0"

  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  multi_az               = var.multi_az
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false

  backup_retention_period = var.backup_retention_period
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"

  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.project}-db-final-${var.environment}"
  deletion_protection       = var.deletion_protection

  performance_insights_enabled = true

  parameter_group_name = aws_db_parameter_group.main.name

  tags = {
    Name        = "${var.project}-db"
    Environment = var.environment
  }
}

resource "aws_db_parameter_group" "main" {
  name   = "${var.project}-db-params-${var.environment}"
  family = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_server"
    value = "utf8mb4_unicode_ci"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "long_query_time"
    value = "2"
  }

  tags = {
    Name = "${var.project}-db-params"
  }
}
