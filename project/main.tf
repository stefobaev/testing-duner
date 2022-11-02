provider "aws" {
    region = var.region
}

module "s3" {
  source = "../modules/s3"
}

module "vpc" {
  source = "../modules/vpc"
}

module "alb" {
  source = "../modules/alb/"
  vpcId = module.vpc.vpcId
  publicSubnet = module.vpc.publicSubnet
}

module "clu" {
  source = "../modules/clu"
  vpcId = module.vpc.vpcId
  privateSubnet = module.vpc.privateSubnet
  iamRoleTreti = module.clu.iamRoleTreti
  listener = module.alb.listener
}

module "codeBuild" {
  source = "../modules/codebuild"
  vpcId = module.vpc.vpcId
  iamRoleTreti = module.clu.iamRoleTreti
  privateSubnet = module.vpc.privateSubnet
  region = module.vpc.region
}

module "init-build" {
    source = "../modules//init-build"
}