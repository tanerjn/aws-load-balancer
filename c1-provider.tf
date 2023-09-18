# Terraform Block
terraform {
  required_version = ">= 1.4" # which means any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.0"
    }    
  }
}


provider "aws" {
  region = "us-east-1"
}


