module "eks" {
  source = "git::https://github.com/HylandSoftware/terraform-aws-delivery-infra-service-catalog.git//aws_compute_eks?ref=main"

  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnet_ids
  log_retention_days = var.log_retention_days
  aws_region         = var.aws_region

}

resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}"
  }

  triggers = {
    cluster_name     = var.cluster_name
    cluster_endpoint = module.eks.cluster_endpoint
    aws_region       = var.aws_region
  }

  depends_on = [module.eks]
}
