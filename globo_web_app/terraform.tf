terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    # No longer needed but now for understanding
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.0"
    }
  }
}