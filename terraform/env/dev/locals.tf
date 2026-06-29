locals {
  project     = "platform"
  environment = "dev"
  common_tags = {
    project     = local.project
    Environment = local.environment
    ManagedBy   = "Terraform"
  }
}