output "application_name" {
    value = kubernetes_manifest.platform_application.manifest.metadata.name
}