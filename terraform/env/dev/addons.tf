module "addons" {


  source = "../../modules/addons"


  depends_on = [

    module.eks

  ]


}