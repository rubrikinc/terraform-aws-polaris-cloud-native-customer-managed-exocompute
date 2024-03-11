output "cluster_ca_certificate" {
  value = "${base64decode(aws_eks_cluster.rsc_exocompute.certificate_authority.0.data)}"
}

output "cluster_connection_command" {
  value = polaris_aws_exocompute_cluster_attachment.cluster.connection_command
}

output "cluster_endpoint" {
  value = aws_eks_cluster.rsc_exocompute.endpoint
} 

output "cluster_name" {
  value = var.aws_eks_cluster_name
}

output "cluster_token" {
  value = data.aws_eks_cluster_auth.rsc_exocompute.token
}

# Output the ssh private key for the worker nodes when local login to nodes is enabled.
output "worker_ssh_private_key" {
  value = var.worker_instance_enable_login ? tls_private_key.worker[0].private_key_pem : null
}