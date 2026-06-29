module "eks" {

  source = "../../modules/eks"

  cluster_name="platform-eks"

  vpc_id = module.vpc.vpc_id

  subnets = module.vpc.private_subnets

}