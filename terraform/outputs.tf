output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "region" {
  description = "AWS region"
  value       = "us-east-1"
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "assets_bucket_name" {
  description = "S3 bucket name for assets"
  value       = "bedrock-assets-${var.student_id}"
}

# Database outputs (Updated to native resources)
output "rds_mysql_endpoint" {
  value = aws_db_instance.mysql.endpoint
  sensitive = true
}

output "rds_postgres_endpoint" {
  value = aws_db_instance.postgres.endpoint
  sensitive = true
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.cart.name
}

output "catalog_secret_arn" {
  value = aws_secretsmanager_secret.catalog_creds.arn
}

output "orders_secret_arn" {
  value = aws_secretsmanager_secret.orders_creds.arn
}
