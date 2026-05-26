variable "student_id" {
  description = "Your unique student ID for resource naming"
  type        = string
}

variable "db_password" {
  description = "Master password for RDS instances"
  type        = string
  sensitive   = true
}

variable "app_namespace" {
  type    = string
  default = "retail-app"
}

variable "eks_cluster_name" {
  type    = string
  default = "project-bedrock-cluster"
}

variable "vpc_name" {
  type    = string
  default = "project-bedrock-vpc"
}
