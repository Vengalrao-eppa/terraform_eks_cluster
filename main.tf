terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "eks" {
  source = "./eks"
}

module "iam" {
  source = "./iam"
}

module "s3" {
  source = "./s3"
  oidc_connect_provider_arn = module.eks.oidc_provider_arn
  vpc_cidr = var.vpc_cidr
}

# output "oidc_provider_arn" {
#   value = module.eks.oidc_provider_arn
# }