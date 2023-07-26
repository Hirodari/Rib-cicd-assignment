locals {
  region       = var.region
  project_name = var.project_name
  environment  = var.environment
}

# create vpc module
module "vpc" {
  source                       = "../terraform-modules/vpc"
  region                       = local.region
  project_name                 = local.project_name
  environment                  = local.environment
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr

}

# create natgateway module 
module "natgateway" {
  source                     = "../terraform-modules/natgateway"
  project_name               = local.project_name
  environment                = local.environment
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id
  internet_gateway           = module.vpc.internet_gateway
  public_subnet_az2_id       = module.vpc.public_subnet_az2_id
  vpc_id                     = module.vpc.vpc_id
  private_app_subnet_az1_id  = module.vpc.private_app_subnet_az1_id
  private_app_subnet_az2_id  = module.vpc.private_app_subnet_az2_id
}

# create security group module
module "security-group" {
  source       = "../terraform-modules/security-group"
  project_name = local.project_name
  environment  = local.environment
  vpc_id       = module.vpc.vpc_id
  ssh_ip       = var.ssh_ip

}

#  create acm module
module "acm" {
  source            = "../terraform-modules/acm"
  domain_name       = var.domain_name
  alternative_names = var.domain_name

}

#  create alb module
module "alb" {
  source               = "../terraform-modules/alb"
  project_name         = local.project_name
  environment          = local.environment
  alb_sg_id            = module.security-group.alb_sg_id
  public_subnet_az1_id = module.vpc.public_subnet_az1_id
  public_subnet_az2_id = module.vpc.public_subnet_az2_id
  vpc_id               = module.vpc.vpc_id
  certificate_arn      = module.acm.certificate_arn

}

#  create s3 module
module "s3" {
  source               = "../terraform-modules/s3"
  project_name         = local.project_name
  env_file_bucket_name = var.env_file_bucket_name
  env_filename         = var.env_filename
}

#  create ecs-role module
module "ecs-role" {
  source               = "../terraform-modules/ecs-role"
  project_name         = local.project_name
  environment          = local.environment
  env_file_bucket_name = var.env_file_bucket_name
}

#  create ecs-role module
module "ecs" {
  source                      = "../terraform-modules/ecs"
  project_name                = local.project_name
  environment                 = local.environment
  ecs_task_execution_role_arn = module.ecs-role.ecs_task_execution_role_arn
  container_image             = var.container_image
  env_file_bucket_name        = var.env_file_bucket_name
  env_filename                = module.s3.env_filename
  region                      = local.region
  cpu_architecture            = var.cpu_architecture
  private_app_subnet_az1_id   = module.vpc.private_app_subnet_az1_id
  private_app_subnet_az2_id   = module.vpc.private_app_subnet_az2_id
  application_sg_id           = module.security-group.application_sg_id
  alb_target_group_arn        = module.alb.alb_target_group_arn
}

#  create asg-ecs module
module "asg-ecs" {
  source       = "../terraform-modules/asg-ecs"
  project_name = local.project_name
  environment  = local.environment
  ecs_service  = module.ecs.ecs_service
}

#  create route-53 module
module "route-53" {
  source                             = "../terraform-modules/route-53"
  domain_name                        = module.acm.domain_name
  record_name                        = var.record_name
  application_load_balancer_dns_name = module.alb.application_load_balancer_dns_name
  application_load_balancer_zone_id  = module.alb.application_load_balancer_zone_id
}

# print the web url
output "website_url" {
  value = join("", ["https://", var.record_name, ".", var.domain_name])
}