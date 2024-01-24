variable "autoscaling_max_size" {
  description = "The maximum number of concurrent workers."
  type        = number
  default     = 64
}

variable "aws_eks_worker_node_role_arn" {
  description = "AWS EKS worker node role name."
  type        = string
}

variable "aws_exocompute_public_subnet_cidr" {
  type        = string
  description = "Public subnet CIDR for the AWS account hosting Exocompute."  
  
}

variable "aws_exocompute_subnet_1_cidr" {
  type        = string
  description = "Subnet 1 CIDR for the AWS account hosting Exocompute."  
  
}

variable "aws_exocompute_subnet_2_cidr" {
  type        = string
  description = "Subnet 2 CIDR for the AWS account hosting Exocompute."  
  
}

variable "aws_exocompute_vpc_cidr" {
  type        = string
  description = "VPC CIDR for the AWS account hosting Exocompute."  
}

variable "aws_iam_cross_account_role_arn" {
  description = "AWS IAM cross account role name."
  type        = string
}


variable "cluster_master_role_arn" {
  description = "Cluster master role ARN."
  type        = string
}

# If private endpoint access is enabled, then K8s API access from worker nodes
# stays within the customer's VPC. Note that this doesn't disable public access,
# cluster remains accessible from public internet as well. For more information,
# see https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html.

variable "enable_private_endpoint_access" {
  description = "Enable EKS private endpoint access."
  type        = bool
  default     = false
}

variable "kubernetes_version" {
    description = "Kubernetes version."
    type        = string
    default     = "1.27"
}

variable "name_prefix" {
  description = "Name prefix for all resources created."
  type        = string
  default     = "rubrik-byok8s"
}

# If restrict public endpoint access is enabled, then the public access to the
# K8s API server endpoint is restricted to the RSC deployment IPs and the
# Bastion IP, otherwise the endpoint remains accessible to the public internet.
# When enabled, we enable the private endpoint access, otherwise there will be
# no way for workers to communicate with the API server.

variable "restrict_public_endpoint_access" {
  description = "Restrict EKS public endpoint access."
  type        = bool
  default     = false
}


variable "rsc_aws_cnp_account_id" {
  type        = string
  description = "Rubrik Security Cloud account ID for the AWS account hosting Exocompute."  
}

variable "rsc_credentials" {
  type        = string
  description = "Path to the Rubrik Security Cloud service account file."
}

# The IP addresses provided will automatically be turned into CIDR addresses.

variable "rsc_deployment_ips" {
  description = "Rubrik Security Cloud deployment IPs. Leaving this blank will use the default IPs."
  type        = list(string)
  default     = []
}

variable "rsc_exocompute_region" {
  type        = string
  description = "AWS region for the Exocompute cluster."  
  
}

variable "worker_instance_profile" {
  description = "Worker instance profile."
  type        = string
}

variable "worker_instance_type" {
  description = "Worker instance type."
  type        = string
  default     = "m5.xlarge"
}