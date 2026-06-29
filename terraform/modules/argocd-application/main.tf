resource "kubernetes_manifest" "platform_application" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind = "Application"
    metadata = {
      name = "platform-app"
      namespace = "argocd"
    } 

    spec = {
      project = "default"
      source = {
        repoURL = var.repo_url
        targetRevision = var.target_revision
        path = var.chart_path
      }

      destination = {
        server = "https://kubernetes.default.svc"
        namespace = var.namespace
      }

      syncPolicy = {
        automated = {
            prune = true
            selfHeal = true
        }
      }
    }
  }
}