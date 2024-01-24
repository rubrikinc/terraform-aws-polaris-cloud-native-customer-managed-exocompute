locals {
  # If public endpoint access is turned off, then private endpoint access must
  # be turned on.
  endpoint_private_access = var.restrict_public_endpoint_access ? true:  var.enable_private_endpoint_access

  # If public endpoint access is turned off, we restrict public access to only
  # RSC.
  public_access_cidrs = var.restrict_public_endpoint_access ? formatlist("%s/32", var.rsc_deployment_ips) : ["0.0.0.0/0"]
}

resource "aws_eks_cluster" "rsc_exocompute" {
  name     = "${var.name_prefix}-rubrik-exocompute-${data.aws_region.current.name}"
  role_arn = var.cluster_master_role_arn
  version  = var.kubernetes_version

  vpc_config {
    endpoint_private_access = local.endpoint_private_access
    public_access_cidrs     = local.public_access_cidrs
    security_group_ids      = [aws_security_group.cluster.id]
    subnet_ids              = [
      aws_subnet.rsc_exocompute_subnet_1.id, 
      aws_subnet.rsc_exocompute_subnet_2.id
    ]
  }
}

data "aws_eks_cluster_auth" "rsc_exocompute" {
  name = "${var.name_prefix}-rubrik-exocompute-${data.aws_region.current.name}"
}