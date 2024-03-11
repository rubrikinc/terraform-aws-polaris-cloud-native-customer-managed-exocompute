data "polaris_deployment" "current" {}

data "aws_eks_cluster_auth" "rsc_exocompute" {
  name = var.aws_eks_cluster_name
}
locals {
  rsc_ip_addresses = [for ip in data.polaris_deployment.current.ip_addresses : "${ip}/32"]
  public_access_cidrs = "${concat(local.rsc_ip_addresses, var.aws_exocompute_public_access_admin_cidr)}"
}

resource "aws_eks_cluster" "rsc_exocompute" {
  name     = var.aws_eks_cluster_name
  role_arn = var.cluster_master_role_arn
  version  = var.kubernetes_version

  vpc_config {
    endpoint_private_access = var.aws_exocompute_public_access ? false : true
    endpoint_public_access  = var.aws_exocompute_public_access ? true : false
    public_access_cidrs     = var.aws_exocompute_public_access ? local.public_access_cidrs : []
    security_group_ids      = [var.aws_security_group_control-plane_id]
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