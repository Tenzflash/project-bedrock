# Security Group for RDS MySQL
resource "aws_security_group" "rds_mysql" {
  name        = "bedrock-catalog-db-sg"
  description = "Security group for Catalog RDS MySQL"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Project = "karatu-2025-capstone", Name = "bedrock-catalog-db-sg" }
}

# Security Group for RDS PostgreSQL
resource "aws_security_group" "rds_postgres" {
  name        = "bedrock-orders-db-sg"
  description = "Security group for Orders RDS PostgreSQL"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Project = "karatu-2025-capstone", Name = "bedrock-orders-db-sg" }
}

# DB Subnet Groups
resource "aws_db_subnet_group" "mysql" {
  name       = "bedrock-catalog-subnet-group"
  subnet_ids = module.vpc.private_subnets
  tags = { Project = "karatu-2025-capstone" }
}

resource "aws_db_subnet_group" "postgres" {
  name       = "bedrock-orders-subnet-group"
  subnet_ids = module.vpc.private_subnets
  tags = { Project = "karatu-2025-capstone" }
}

# RDS MySQL for Catalog Service
resource "aws_db_instance" "mysql" {
  identifier              = "bedrock-catalog-db"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = "catalogdb"
  username                = "catalog_admin"
  password                = var.db_password
  port                    = 3306
  vpc_security_group_ids  = [aws_security_group.rds_mysql.id]
  db_subnet_group_name    = aws_db_subnet_group.mysql.name
  publicly_accessible     = false
  skip_final_snapshot     = true
  storage_encrypted       = true
  tags = { Project = "karatu-2025-capstone", Component = "catalog-database" }
}

# RDS PostgreSQL for Orders Service
resource "aws_db_instance" "postgres" {
  identifier              = "bedrock-orders-db"
  engine                  = "postgres"
  engine_version          = "15.7"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = "ordersdb"
  username                = "orders_admin"
  password                = var.db_password
  port                    = 5432
  vpc_security_group_ids  = [aws_security_group.rds_postgres.id]
  db_subnet_group_name    = aws_db_subnet_group.postgres.name
  publicly_accessible     = false
  skip_final_snapshot     = true
  storage_encrypted       = true
  tags = { Project = "karatu-2025-capstone", Component = "orders-database" }
}

# DynamoDB for Cart Service
resource "aws_dynamodb_table" "cart" {
  name         = "bedrock-cart-items"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"
  range_key    = "sessionId"

  attribute {
    name = "userId"
    type = "S"
  }
  attribute {
    name = "sessionId"
    type = "S"
  }

  tags = { Project = "karatu-2025-capstone", Component = "cart-database" }
}

# Secrets Manager for Catalog
resource "aws_secretsmanager_secret" "catalog_creds" {
  name = "bedrock-catalog-db-credentials"
  tags = { Project = "karatu-2025-capstone" }
}

resource "aws_secretsmanager_secret_version" "catalog_creds" {
  secret_id = aws_secretsmanager_secret.catalog_creds.id
  secret_string = jsonencode({
    username = "catalog_admin"
    password = var.db_password
    host     = aws_db_instance.mysql.endpoint
    port     = 3306
    database = "catalogdb"
  })
}

# Secrets Manager for Orders
resource "aws_secretsmanager_secret" "orders_creds" {
  name = "bedrock-orders-db-credentials"
  tags = { Project = "karatu-2025-capstone" }
}

resource "aws_secretsmanager_secret_version" "orders_creds" {
  secret_id = aws_secretsmanager_secret.orders_creds.id
  secret_string = jsonencode({
    username = "orders_admin"
    password = var.db_password
    host     = aws_db_instance.postgres.endpoint
    port     = 5432
    database = "ordersdb"
  })
}
