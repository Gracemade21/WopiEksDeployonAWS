output "namespace_name" {
  description = "Kubernetes namespace name"
  value       = kubernetes_namespace.wopi_services.metadata[0].name
}