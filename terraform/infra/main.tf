module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  az                  = var.az

}

module "eks" {
  source            = "./modules/eks"
  vpc_cni_role_arn  = module.iam.vpc_cni_role_arn
  cluster_role_arn  = module.iam.cluster_role_arn
  subnet_id         = module.vpc.private_subnet_id
  eso_role_arn      = module.iam.eso_role_arn
  ebs_csi_role_arn  = module.iam.ebs_csi_role_arn
  node_role_arn     = module.iam.node_role_arn
  lb_controller_arn = module.iam.lb_controller_role_arn
  cert_manager_role_arn = module.iam.cert_manager_role_arn

  depends_on = [module.iam]
}

module "rds" {
  source     = "./modules/rds"
  db_sg_id   = module.vpc.db_sg_id
  subnet_ids = module.vpc.private_subnet_id
}

module "valkey" {
  source            = "./modules/valkey"
  valkey_sg_id      = module.vpc.valkey_sg_id
  private_subnet_id = module.vpc.private_subnet_id
}

module "nlb" {
  source     = "./modules/nlb"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_id
  nlb_sg_id  = module.vpc.nlb_sg_id
  # certificate_arn =  module.acm.certificate_arn
}

module "iam" {
  source              = "./modules/iam"
  valkey_endpoint_arn = module.valkey.valkey_endpoint_arn
  route53_hosted_zone_id = module.route53.route53_hosted_zone_id
}

# module "acm" {
#   source = "./modules/acm" 
# }

# module "acm_validation" {
#   source = "./modules/acm_validation"
#   acm_certificate_arn =  module.acm.certificate_arn
#   dns_validation_record = module.route53.acm_validation_fqdn
# }

module "route53" {
  source       = "./modules/route53"
  nlb_dns_name = module.nlb.nlb_dns_name
  nlb_zone_id  = module.nlb.nlb_zone_id
  # acm_validation_name =  module.acm.acm_validation_name
  # acm_validation_record = module.acm.acm_validation_record
}