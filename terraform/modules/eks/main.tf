module "eks" {


  source = "terraform-aws-modules/eks/aws"


  version = "~>20.0"


  cluster_name = var.cluster_name


  cluster_version = "1.30"

  enable_cluster_creator_admin_permissions = true

  cluster_endpoint_public_access = true

  cluster_endpoint_private_access = false

  cluster_endpoint_public_access_cidrs = [
    "0.0.0.0/0"
  ]



  vpc_id = var.vpc_id


  subnet_ids = var.subnets



  eks_managed_node_groups = {


    platform = {


      desired_size = 2

      min_size = 1

      max_size = 3


      instance_types = ["t3.medium"]


    }


  }


}
