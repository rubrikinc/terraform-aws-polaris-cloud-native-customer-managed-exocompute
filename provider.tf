terraform {
  required_version = ">=1.5.6"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>5.26.0"
    }
    polaris = {
      source  = "rubrikinc/polaris"
      version = "=0.8.0-beta.11"
    }
  }
}

provider "aws" {
    profile = var.aws_profile
    region = var.rsc_exocompute_region
}

provider "polaris" {
  credentials = var.rsc_credentials
}

provider "kubernetes" {
  host                   = aws_eks_cluster.rsc_exocompute.endpoint
  cluster_ca_certificate = "${base64decode(aws_eks_cluster.rsc_exocompute.certificate_authority.0.data)}"
  token                  = data.aws_eks_cluster_auth.rsc_exocompute.token
#  load_config_file       = false
}