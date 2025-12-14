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
    host              = var.db_host
    port              = tostring(var.db_port)
    username          = var.db_username
    password          = var.db_password
    database          = var.db_name
    endpoint          = "${var.db_host}:${var.db_port}"
    connection_string = var.connection_string
    secret_arn        = var.db_secret_arn
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