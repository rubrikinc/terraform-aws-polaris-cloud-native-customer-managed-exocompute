
# Output the ssh private key for the worker nodes when local login to nodes is enabled.
output "worker_ssh_private_key" {
  value = var.worker_instance_enable_login ? tls_private_key.worker[0].private_key_pem : null
}