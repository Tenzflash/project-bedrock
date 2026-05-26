module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.8.0"

  cluster_name    = var.eks_cluster_name
  cluster_version = "1.34"

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    primary = {
      min_size     = 1
      max_size     = 2
      desired_size = 2
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }

  enable_irsa = true
  enable_cluster_creator_admin_permissions = true

  # Disable KMS encryption by setting empty config (safe for capstone)
  cluster_encryption_config = []

  tags = {
    Project = "karatu-2025-capstone"
  }
}
