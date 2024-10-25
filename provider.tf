data "aws_caller_identity" "current" {}
terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }

  backend "s3" {
    bucket  = "gds-security-terraform"
    key     = "terraform/state/account/cst-test/service/misp.tfstate"
    region  = "eu-west-2"
    profile = "cst-prod"
    encrypt = true
    }
}

provider "aws" {
  region     = "eu-west-2"
  profile    = var.profile

  default_tags {
    tags = {
      Environment = var.environment
      Owner       = var.owner
      Project     = var.project
    }
  }
}
