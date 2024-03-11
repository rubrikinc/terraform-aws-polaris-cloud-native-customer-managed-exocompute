variable "autoscaling_max_size" {
  description = "The maximum number of concurrent workers."
  type        = number
  default     = 64
}

variable "aws_autoscaling_group_name" {
  description = "The name of the autoscaling group for Exocompute."
  type        = string
  default     = "Rubrik-Exocompute-Launch-Template-Customer-Managed" 
}
variable "aws_eks_cluster_name" {
  description = "EKS cluster name."
  type        = string
  default     = "Rubrik-Exocompute-Customer-Managed"
}
variable "aws_eks_worker_node_role_arn" {
  description = "AWS EKS worker node role name."
  type        = string
}

variable "aws_exocompute_public_access_admin_cidr" {
  description = "Public access admin IP CIDR for the Exocompute cluster. Needed whe running kubectl commands from outside of AWS. Can be blank"
  type        = list(string)
  default     = []
}
variable "aws_exocompute_public_access" {
  description = "Enable public access to the Exocompute cluster."
  type        = bool
  default     = true
}

variable "aws_iam_cross_account_role_arn" {
  description = "AWS IAM cross account role name."
  type        = string
}

variable "aws_launch_template_name" {
  description = "The name of the launch template for the worker nodes."
  type        = string
  default     = "Rubrik-Exocompute-Launch-Template-Customer-Managed"
}

variable "aws_profile" {
  description = "AWS profile name."
  type        = string  
}

variable "aws_security_group_control-plane_id" {
  description = "Security group ID for the EKS control plane."
  type        = string
}

variable "aws_security_group_worker-node_id" {
  description = "Security group ID for the EKS worker nodes."
  type        = string
}

variable "cluster_master_role_arn" {
  description = "Cluster master role ARN."
  type        = string
}

variable "kubernetes_version" {
    description = "Kubernetes version."
    type        = string
    default     = "1.27"
}

variable "rsc_aws_cnp_account_id" {
  type        = string
  description = "Rubrik Security Cloud account ID for the AWS account hosting Exocompute."  
}

variable "rsc_credentials" {
  type        = string
  description = "Path to the Rubrik Security Cloud service account file."
}

variable "rsc_exocompute_region" {
  type        = string
  description = "AWS region for the Exocompute cluster."    
}

variable "rsc_exocompute_subnet_1_id" {
  type        = string
  description = "Subnet 1 ID for the AWS account hosting Exocompute."  
  
}

variable "rsc_exocompute_subnet_2_id" {
  type        = string
  description = "Subnet 2 ID for the AWS account hosting Exocompute."  
  
}

variable "worker_instance_enable_login" {
  description = "Enable login to worker instances. Generates a key pair and stores it in a local *.pem file."
  type        = bool
  default     = false
}

variable "worker_instance_node_name" {
  description = "Worker instance node name."
  type        = string
  default     = "Rubrik-Exocompute-Customer-Managed-Node"
}

variable "worker_instance_profile" {
  description = "Worker instance profile."
  type        = string
}

variable "worker_instance_type" {
  description = "Worker instance type."
  type        = string
  default     = "m5.2xlarge"
}

