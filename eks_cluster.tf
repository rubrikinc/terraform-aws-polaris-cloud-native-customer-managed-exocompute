data "aws_eks_cluster_auth" "rsc_exocompute" {
  name = var.aws_eks_cluster_name
}
locals {
  # If public endpoint access is turned off, then private endpoint access must
  # be turned on.
  endpoint_private_access = var.restrict_public_endpoint_access ? true:  var.enable_private_endpoint_access

  # If public endpoint access is turned off, we restrict public access to only
  # RSC.
  public_access_cidrs = var.restrict_public_endpoint_access ? formatlist("%s/32", var.rsc_deployment_ips) : ["0.0.0.0/0"]
}

resource "aws_eks_cluster" "rsc_exocompute" {
  name     = var.aws_eks_cluster_name
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

#EKS cluster default security group rules.

resource "aws_vpc_security_group_ingress_rule" "default_eks_cluster_from_control_plane_sg" {
  description = "Inbound traffic from cluster control plane"

  security_group_id            = aws_eks_cluster.rsc_exocompute.vpc_config[0].cluster_security_group_id
  referenced_security_group_id = var.aws_security_group_control-plane_id

  ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "default_eks_cluster_from_worker_node_sg" {
  description = "Inbound traffic from cluster control plane"

  security_group_id            = aws_eks_cluster.rsc_exocompute.vpc_config[0].cluster_security_group_id
  referenced_security_group_id = var.aws_security_group_worker-node_id

  ip_protocol = "-1"
}