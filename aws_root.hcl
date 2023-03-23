locals {
  TERRAFORM_STATE_BUCKET = ""
  DYNAMODB_TABLE         = ""
  AWS_REGION             = ""
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = local.TERRAFORM_STATE_BUCKET

    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = local.AWS_REGION
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  assume_role {
    region = "${local.AWS_REGION}"
  }
}
EOF
}
