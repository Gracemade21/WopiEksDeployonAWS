module "eks" {
  source = "./modules/eks"

  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnet_ids
  log_retention_days = var.log_retention_days
  aws_region         = var.aws_region

}

module "rds" {
  source = "./modules/rds"

  cluster_name               = var.cluster_name
  vpc_id                     = var.vpc_id
  private_subnet_ids         = var.private_subnet_ids
  vpc_cidr                   = var.vpc_cidr
  db_allocated_storage       = var.db_allocated_storage
  db_max_allocated_storage   = var.db_max_allocated_storage
  db_engine_version          = var.db_engine_version
  db_instance_class          = var.db_instance_class
  db_backup_retention_period = var.db_backup_retention_period
  db_backup_window           = var.db_backup_window
  db_maintenance_window      = var.db_maintenance_window
  skip_final_snapshot        = var.skip_final_snapshot
  deletion_protection        = var.deletion_protection


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

  namespace_name         = "wopi-services"
  environment            = var.environment
  db_address             = module.rds.db_instance_address
  db_port                = module.rds.db_instance_port
  db_endpoint            = module.rds.db_instance_endpoint
  db_username            = "admin"
  db_password_secret_arn = module.rds.db_password_secret_arn
  redis_host             = module.redis.primary_endpoint_address
  redis_port             = module.redis.port
  redis_endpoint         = var.redis_num_cache_clusters > 1 ? module.redis.configuration_endpoint_address : module.redis.primary_endpoint_address

  depends_on = [module.eks, module.rds, module.redis]
}
