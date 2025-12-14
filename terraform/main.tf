module "eks" {
  source = "./modules/eks"

  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnet_ids
  log_retention_days = var.log_retention_days
  aws_region         = var.aws_region

}

# NEW: External database configuration
module "database" {
  source = "./modules/database-config"

  db_secret_name = var.db_secret_name
  db_host        = var.db_host
  db_port        = var.db_port
  db_name        = var.db_name
  tags = merge(var.tags, {
    CostCenter           = "CC5409"
    CustomerName         = "Hyland Software Inc"
    EnvironmentType      = "Sandbox"
    Owner                = "CPEENBL"
    Platform             = "AWS Delivery"
    Product              = "OnBase"
    git_commit           = "15f3b7df3d4213975dbf3b4c4ff4f3dc9fd9983b"
    git_file             = "wopieksdeploy/terraform/main.tf"
    git_last_modified_at = "2025-12-11 21:55:39"
    git_last_modified_by = "16985548+stamo57@users.noreply.github.com"
    git_modifiers        = "16985548+stamo57/nnabuife.ike"
    git_org              = "HylandSoftware"
    git_repo             = "enbl-eks-wopi-standalone-offering"
    source               = "yor"
    yor_name             = "database"
    yor_trace            = "0dd39079-826f-44bd-a6e1-81e328d2ae78"
  })

  depends_on = [module.eks]
}

module "redis" {
  source = "./modules/redis"

  cluster_name             = var.cluster_name
  vpc_id                   = var.vpc_id
  private_subnet_ids       = var.private_subnet_ids
  vpc_cidr                 = var.vpc_cidr
  redis_node_type          = var.redis_node_type
  redis_parameter_group    = var.redis_parameter_group
  redis_num_cache_clusters = var.redis_num_cache_clusters


  depends_on = [module.eks]
}

module "kubernetes" {
  source = "./modules/kubernetes"

  namespace_name = "wopi-services"
  environment    = var.environment

  # External database connection info
  db_host           = module.database.db_host
  db_port           = module.database.db_port
  db_name           = module.database.db_name
  db_username       = module.database.db_username
  db_password       = module.database.db_password
  connection_string = module.database.connection_string
  db_secret_arn     = module.database.secret_arn

  # Redis info
  redis_host     = module.redis.primary_endpoint_address
  redis_port     = module.redis.port
  redis_endpoint = var.redis_num_cache_clusters > 1 ? module.redis.configuration_endpoint_address : module.redis.primary_endpoint_address

  depends_on = [module.eks, module.redis]
}
