terraform {
  backend "s3" {
    bucket       = "tf-state-8864"
    key          = "tf-s3-global-state/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.99.1"
    }
  }

  required_version = ">= 1.12"
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Name        = var.project_name
      Environment = var.environment
    }
  }
}

