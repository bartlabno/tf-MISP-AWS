terraform {
  source = "../."
}

inputs = {
  owner       = "Cabinet Office"
  environment = "test"
  project     = "misp"
  base_domain = "misp.staging.gds-cyber-security.digital"

  image_version = "latest"

  block_cidr = "10.30.0.0/16"
}

remote_state {
  backend = "s3"
  config = {
    bucket  = "gds-security-terraform-staging"
    key     = "staging/misp/services/misp.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}