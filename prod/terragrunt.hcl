terraform {
  source = "../."
}

inputs = {
  owner       = "The Company"
  environment = "example-env"
  project     = "misp"
  base_domain = "misp.example.com"

  profile = "misp"

  image_version = "latest"

  block_cidr = "10.0.0.0/16"
}

remote_state {
  backend = "s3"
  config = {
    bucket  = "your-terraform-state-bucket"
    key     = "terraform/state/account/environment/misp.tfstate"
    region  = "eu-west-2"
    profile = "steate-profile"
    encrypt = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}