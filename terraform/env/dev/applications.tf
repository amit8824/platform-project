module "argocd_application" {
  source          = "../../modules/argocd-application"
  repo_url        = "https://github.com/amit8824/platform-project"
  target_revision = "main"
  chart_path      = "helm/platform-chart"
  namespace       = "default"
  depends_on      = [module.addons]
}
