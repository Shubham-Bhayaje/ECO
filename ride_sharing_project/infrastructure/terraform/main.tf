# ==========================================================
# EcoRide Infrastructure as Code (Terraform)
# Zero Vendor Lock-in Architecture
# ==========================================================

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.20"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# 1. VPC & Subnets
resource "aws_vpc" "ecoride_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "ecoride-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.ecoride_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.ecoride_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "ecoride-rds-subnet-group"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
}

# 2. Security Group for PostgreSQL RDS
resource "aws_security_group" "rds_sg" {
  name        = "ecoride-rds-sg"
  description = "Security group for PostgreSQL RDS"
  vpc_id      = aws_vpc.ecoride_vpc.id

  ingress {
    description = "PostgreSQL access from API instances"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. AWS RDS PostgreSQL 15 Instance with PostGIS
resource "aws_db_instance" "ecoride_rds_postgres" {
  identifier             = "ecoride-postgres-db"
  allocated_storage      = 20
  max_allocated_storage  = 100
  engine                 = "postgres"
  engine_version         = "15.5"
  instance_class         = "db.t4g.micro"
  db_name                = "ecoride_db"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  storage_encrypted      = true

  tags = {
    Name        = "ecoride-rds-postgres"
    Environment = var.environment
  }
}

# 4. HashiCorp Vault / AWS Secrets Manager
resource "aws_secretsmanager_secret" "ecoride_app_secrets" {
  name                    = "ecoride/production/secrets"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "ecoride_secrets_val" {
  secret_id = aws_secretsmanager_secret.ecoride_app_secrets.id
  secret_string = jsonencode({
    DB_HOST     = aws_db_instance.ecoride_rds_postgres.address
    DB_PORT     = 5432
    DB_NAME     = "ecoride_db"
    DB_USER     = var.db_username
    DB_PASSWORD = var.db_password
    JWT_SECRET  = var.jwt_secret
  })
}

# Variables
variable "aws_region" {
  type    = string
  default = "ap-south-1" # Mumbai region for minimum latency
}

variable "environment" {
  type    = string
  default = "production"
}

variable "db_username" {
  type    = string
  default = "ecoride_admin"
}

variable "db_password" {
  type      = string
  sensitive = true
  default   = "ChangeMeInVaultProduction123!"
}

variable "jwt_secret" {
  type      = string
  sensitive = true
  default   = "EcoRideHmacSuperSecretKey2025"
}
