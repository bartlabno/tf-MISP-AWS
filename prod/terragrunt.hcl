terraform {
  source = "../."
}

inputs = {
  owner       = "Cabinet Office"
  environment = "prod"
  project     = "misp"
  base_domain = "misp.cyber-security.digital.cabinet-office.gov.uk"

  profile = "cst-prod"

  image_version = "latest"

  block_cidr = "10.30.0.0/16"
}

remote_state {
  backend = "s3"
  config = {
    bucket  = "gds-security-terraform"
    key     = "terraform/state/account/cst-test/service/misp.tfstate"
    region  = "eu-west-2"
    profile = "cst-prod"
    encrypt = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}