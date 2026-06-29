resource "kubernetes_namespace" "argocd" {

  metadata {
    name = "argocd"
  }

}


resource "helm_release" "argocd" {

  name = "argocd"

  repository = "https://argoproj.github.io/argo-helm"

  chart = "argo-cd"

  namespace = kubernetes_namespace.argocd.metadata[0].name
  
  create_namespace = false

  wait = true

  timeout = 600
}



resource "kubernetes_namespace" "rollouts" {

  metadata {
    name = "argo-rollouts"
  }

}


resource "helm_release" "rollouts" {

  name = "argo-rollouts"

  repository = "https://argoproj.github.io/argo-helm"

  chart = "argo-rollouts"

  namespace = kubernetes_namespace.rollouts.metadata[0].name
  
  wait = true

  timeout = 600
}



resource "kubernetes_namespace" "monitoring" {

  metadata {
    name = "monitoring"
  }

}


resource "helm_release" "prometheus" {

  name = "monitoring"

  repository = "https://prometheus-community.github.io/helm-charts"

  chart = "kube-prometheus-stack"

  namespace = kubernetes_namespace.monitoring.metadata[0].name
  
  wait = true

  timeout = 600
}