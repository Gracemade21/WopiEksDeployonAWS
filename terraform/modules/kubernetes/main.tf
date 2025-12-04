data "aws_secretsmanager_secret_version" "db_password" {
  secret_id  = var.db_password_secret_arn
}

locals {
  db_password = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]
}

resource "kubernetes_namespace" "wopi_services" {
  metadata {
    name = var.namespace_name
    labels = {
      name        = var.namespace_name
      environment = var.environment
      managed-by  = "terraform"
    }
  }
}

resource "kubernetes_secret" "database" {
  metadata {
    name      = "wopi-database-secret"
    namespace = kubernetes_namespace.wopi_services.metadata[0].name
    labels = {
      app        = "wopi"
      component  = "database"
      managed-by = "terraform"
    }
  }

  type = "Opaque"

  data = {
    host              = var.db_address
    port              = tostring(var.db_port)
    username          = var.db_username
    password          = local.db_password
    database          = "wopi_database"
    endpoint          = var.db_endpoint
    connection_string = "Server=${var.db_address},${var.db_port};Database=wopi_database;User Id=${var.db_username};Password=${local.db_password};TrustServerCertificate=true;"
  }
}

resource "kubernetes_secret" "redis" {
  metadata {
    name      = "wopi-redis-secret"
    namespace = kubernetes_namespace.wopi_services.metadata[0].name
    labels = {
      app        = "wopi"
      component  = "cache"
      managed-by = "terraform"
    }
  }

  type = "Opaque"

  data = {
    redis_host              = var.redis_host
    redis_port              = tostring(var.redis_port)
    redis_endpoint          = var.redis_endpoint
    redis_connection_string = "${var.redis_host}:${var.redis_port}"
  }
}