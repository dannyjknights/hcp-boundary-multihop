terraform {
  required_providers {
    boundary = {
      source  = "hashicorp/boundary"
      version = ">=1.0.7"
    }
    http = {
      source  = "hashicorp/http"
      version = ">=3.2.1"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = ">=2.3.2"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = ">=0.56.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

provider "boundary" {
  addr                            = var.boundary_addr
  auth_method_id                  = var.auth_method_id
  password_auth_method_login_name = var.password_auth_method_login_name
  password_auth_method_password   = var.password_auth_method_password

}
