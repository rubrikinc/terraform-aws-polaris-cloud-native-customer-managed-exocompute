# Terraform Module - AWS Rubrik Cloud Native Customer Hosted Exocompute

This module adds a customer hosted Exocompute cluster configuration to the Rubrik Security Cloud.

## Prerequisites

There are a few services you'll need in order to get this project off the ground:

- [Terraform](https://www.terraform.io/downloads.html) v1.5.6 or greater
- [Rubrik Polaris Provider for Terraform](https://github.com/rubrikinc/terraform-provider-polaris) - provides Terraform functions for Rubrik Security Cloud (Polaris)
- [Install the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) - Needed for Terraform to authenticate with AWS

## Usage

```hcl
# Deploy Exocompute configuration with inputs provided separately.

module "polaris-aws-cloud-native-customer-managed-exocompute" {
  source  = "rubrikinc/polaris-cloud-native-customer-managed-exocompute/aws"
  
  aws_exocompute_public_subnet_cidr   = "172.20.0.0/24"
  aws_exocompute_subnet_1_cidr        = "172.20.1.0/24"
  aws_exocompute_subnet_2_cidr        = "172.20.2.0/24"
  aws_exocompute_vpc_cidr             = "172.20.0.0/16"
  aws_eks_worker_node_role_arn        = "arn:aws:iam::0123456789ab:role/rubrik-exocompute_eks_workernode-20240116071747815700000002"
  aws_iam_cross_account_role_arn      = "arn:aws:iam::0123456789ab:role/rubrik-crossaccount-20240116071747824700000003"
  cluster_master_role_arn             = "arn:aws:iam::0123456789ab:role/rubrik-exocompute_eks_masternode-20240116071747814700000001"
  rsc_aws_cnp_account_id              = "01234567-89ab-cdef-0123-456789abcdef"
  rsc_credentials                     = "../.creds/customer-service-account.json"
  rsc_exocompute_region               = "us-east-1"
  worker_instance_profile             = "rubrik-exocompute_eks_workernode-20240116071750336400000004"
}
```

```hcl
# Deploy Exocompute configuration with inputs provided by the polaris-aws-cloud-native module.

module "polaris-aws-cloud-native" {
  source  = "rubrikinc/polaris-cloud-native/aws"
  
  aws_account_name                    = "my_aws_account_hosted_exocompute"
  aws_account_id                      = "123456789012"
  aws_regions                         = ["us-west-2","us-east-1"]
  rsc_credentials                     = "../.creds/customer-service-account.json"
  rsc_aws_features                    = [
                                          "CLOUD_NATIVE_PROTECTION",
                                          "RDS_PROTECTION",
                                          "CLOUD_NATIVE_S3_PROTECTION",
                                          "EXOCOMPUTE",
                                          "CLOUD_NATIVE_ARCHIVAL"
                                        ]
}

module "polaris-aws-cloud-native-customer-managed-exocompute" {
  source  = "rubrikinc/polaris-cloud-native-customer-managed-exocompute/aws"
  
  aws_exocompute_public_subnet_cidr   = "172.20.0.0/24"
  aws_exocompute_subnet_1_cidr        = "172.20.1.0/24"
  aws_exocompute_subnet_2_cidr        = "172.20.2.0/24"
  aws_exocompute_vpc_cidr             = "172.20.0.0/16"
  aws_eks_worker_node_role_arn        = module.polaris-aws-cloud-native.aws_eks_worker_node_role_arn
  aws_iam_cross_account_role_arn      = module.polaris-aws-cloud-native.aws_iam_cross_account_role_arn
  cluster_master_role_arn             = module.polaris-aws-cloud-native.cluster_master_role_arn
  rsc_aws_cnp_account_id              = module.polaris-aws-cloud-native.rsc_aws_cnp_account_id
  rsc_credentials                     = "../.creds/customer-service-account.json"
  rsc_exocompute_region               = "us-east-1"
  worker_instance_profile             = module.polaris-aws-cloud-native.worker_instance_profile
}
```

<!-- BEGIN_TF_DOCS -->


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.5.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>5.26.0 |
| <a name="requirement_polaris"></a> [polaris](#requirement\_polaris) | =0.8.0-beta.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.26.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.25.2 |
| <a name="provider_polaris"></a> [polaris](#provider\_polaris) | 0.8.0-beta.8 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.10.0 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_eip.rsc_exocompute_nat_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eks_cluster.rsc_exocompute](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_internet_gateway.rsc_exocompute](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_launch_template.worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_nat_gateway.rsc_exocompute](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.rsc_exocompute_private_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.rsc_exocompute_public_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.rsc_exocompute_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.rsc_exocompute_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.rsc_exocompute_private_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.rsc_exocompute_private_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.rsc_exocompute_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.rsc_exocompute_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.rsc_exocompute_subnet_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.rsc_exocompute_subnet_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.rsc_exocompute](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_endpoint.autoscaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecr_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecr_dkr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.rsc_exocompute](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_security_group_egress_rule.cluster_worker_1025_65535](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.worker_all_ipv4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.cluster_worker_443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.worker_cluster_1025_65535](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.worker_cluster_443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.worker_worker_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [kubernetes_config_map.aws_auth_configmap](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [polaris_aws_exocompute.rsc_managed](https://registry.terraform.io/providers/rubrikinc/polaris/0.8.0-beta.8/docs/resources/aws_exocompute) | resource |
| [time_sleep.wait_for_polaris_sync](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_eks_cluster_auth.exocompute_cluster_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_eks_cluster_auth.rsc_exocompute](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_ssm_parameter.worker_image](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoscaling_max_size"></a> [autoscaling\_max\_size](#input\_autoscaling\_max\_size) | The maximum number of concurrent workers. | `number` | `64` | no |
| <a name="input_aws_autoscaling_group_name"></a> [aws\_autoscaling\_group\_name](#input\_aws\_autoscaling\_group\_name) | The name of the autoscaling group for Exocompute. | `string` | `"Rubrik-Exocompute-Launch-Template-Customer-Managed"` | no |
| <a name="input_aws_eks_cluster_name"></a> [aws\_eks\_cluster\_name](#input\_aws\_eks\_cluster\_name) | EKS cluster name. | `string` | `"Rubrik-Exocompute-Customer-Managed"` | no |
| <a name="input_aws_eks_worker_node_role_arn"></a> [aws\_eks\_worker\_node\_role\_arn](#input\_aws\_eks\_worker\_node\_role\_arn) | AWS EKS worker node role name. | `string` | n/a | yes |
| <a name="input_aws_exocompute_public_access_admin_cidr"></a> [aws\_exocompute\_public\_access\_admin\_cidr](#input\_aws\_exocompute\_public\_access\_admin\_cidr) | Public access admin IP CIDR for the Exocompute cluster. Needed whe running kubectl commands from outside of AWS. Can be blank | `list(string)` | `[]` | no |
| <a name="input_aws_iam_cross_account_role_arn"></a> [aws\_iam\_cross\_account\_role\_arn](#input\_aws\_iam\_cross\_account\_role\_arn) | AWS IAM cross account role name. | `string` | n/a | yes |
| <a name="input_aws_launch_template_name"></a> [aws\_launch\_template\_name](#input\_aws\_launch\_template\_name) | The name of the launch template for the worker nodes. | `string` | `"Rubrik-Exocompute-Launch-Template-Customer-Managed"` | no |
| <a name="input_cluster_master_role_arn"></a> [cluster\_master\_role\_arn](#input\_cluster\_master\_role\_arn) | Cluster master role ARN. | `string` | n/a | yes |
| <a name="input_enable_private_endpoint_access"></a> [enable\_private\_endpoint\_access](#input\_enable\_private\_endpoint\_access) | Enable EKS private endpoint access. | `bool` | `false` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version. | `string` | `"1.27"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name prefix for all resources created. | `string` | `"rubrik-byok8s"` | no |
| <a name="input_restrict_public_endpoint_access"></a> [restrict\_public\_endpoint\_access](#input\_restrict\_public\_endpoint\_access) | Restrict EKS public endpoint access. | `bool` | `false` | no |
| <a name="input_rsc_aws_cnp_account_id"></a> [rsc\_aws\_cnp\_account\_id](#input\_rsc\_aws\_cnp\_account\_id) | Rubrik Security Cloud account ID for the AWS account hosting Exocompute. | `string` | n/a | yes |
| <a name="input_rsc_credentials"></a> [rsc\_credentials](#input\_rsc\_credentials) | Path to the Rubrik Security Cloud service account file. | `string` | n/a | yes |
| <a name="input_rsc_deployment_ips"></a> [rsc\_deployment\_ips](#input\_rsc\_deployment\_ips) | Rubrik Security Cloud deployment IPs. Leaving this blank will use the default IPs. | `list(string)` | `[]` | no |
| <a name="input_rsc_exocompute_region"></a> [rsc\_exocompute\_region](#input\_rsc\_exocompute\_region) | AWS region for the Exocompute cluster. | `string` | n/a | yes |
| <a name="input_worker_instance_enable_login"></a> [worker\_instance\_enable\_login](#input\_worker\_instance\_enable\_login) | Enable login to worker instances. Generates a key pair and stores it in a local *.pem file. | `bool` | `false` | no |
| <a name="input_worker_instance_node_name"></a> [worker\_instance\_node\_name](#input\_worker\_instance\_node\_name) | Worker instance node name. | `string` | `"Rubrik-Exocompute-Customer-Managed-Node"` | no |
| <a name="input_worker_instance_profile"></a> [worker\_instance\_profile](#input\_worker\_instance\_profile) | Worker instance profile. | `string` | n/a | yes |
| <a name="input_worker_instance_type"></a> [worker\_instance\_type](#input\_worker\_instance\_type) | Worker instance type. | `string` | `"m5.2xlarge"` | no |

## Outputs

No outputs.


<!-- END_TF_DOCS -->

## Troubleshooting

### Connection Refused Error during destroy operation
When removing/destroying this module you may encounter the following error:

```
╷
│ Error: Get "http://localhost/api/v1/namespaces/kube-system/configmaps/aws-auth": dial tcp 127.0.0.1:80: connect: connection refused
│ 
│   with kubernetes_config_map.aws_auth_configmap,
│   on config_map.tf line 5, in resource "kubernetes_config_map" "aws_auth_configmap":
│    5: resource "kubernetes_config_map" "aws_auth_configmap" {
│ 
╵
```

This is due to a bug in the `kubernetes_config_map` resource as described [here](https://github.com/terraform-aws-modules/terraform-aws-eks/issues/978). To workaround this issue remove the `kubernetes_config_map.aws_auth_configmap` resource from the Terraform state file using the following command:

`terraform state rm kubernetes_config_map.aws_auth_configmap`