data "aws_region" "current" {}

# Temporary fix until this error is resolved:
# │ Error: failed to lookup exocompute config: failed to get vpcs: failed to 
# | request allVpcsByRegionFromAws: graphql response body is an error (status code 200): Objects 
# | are not authorized (code: 403, traceId: x9TBQt14uQpe5tSLU2BDEQ==) | error is

resource "time_sleep" "wait_for_polaris_sync" {
  create_duration = "60s"
}

# Create an Exocompute configuration using the specified VPC and subnets.
resource "polaris_aws_exocompute" "customer_managed" {
  account_id              = var.rsc_aws_cnp_account_id
  region                  = data.aws_region.current.name
  
  depends_on = [time_sleep.wait_for_polaris_sync]
}

resource "time_sleep" "wait_for_exocompute_registration" {
  create_duration = "60s"
}

resource "polaris_aws_exocompute_cluster_attachment" "cluster" {
  exocompute_id = polaris_aws_exocompute.customer_managed.id
  cluster_name  = var.aws_eks_cluster_name

  depends_on = [time_sleep.wait_for_exocompute_registration]
}