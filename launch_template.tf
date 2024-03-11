locals {
  # For the us-east-1 region the hostname suffix is compute.internal. For all
  # other regions, the hostname suffix is in the form <region>.compute.internal.
  hostname = data.aws_region.current.name == "us-east-1" ? "compute.internal" : "${data.aws_region.current.name}.compute.internal"
}

# https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html.
data "aws_ssm_parameter" "worker_image" {
  name = "/aws/service/eks/optimized-ami/${var.kubernetes_version}/amazon-linux-2/recommended/image_id"
}

data "aws_iam_account_alias" "current" {}

# Create ssh key material for the worker nodes.
resource "tls_private_key" "worker" {
  count = var.worker_instance_enable_login ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}
# Create ssh key for the worker nodes.
resource "aws_key_pair" "worker" {
  count = var.worker_instance_enable_login ? 1 : 0
  key_name   = "rubrik-exocompute-worker"
  public_key = tls_private_key.worker[0].public_key_openssh
}

resource "aws_launch_template" "worker" {
  name                   = var.aws_launch_template_name
  image_id               = data.aws_ssm_parameter.worker_image.value
  instance_type          = var.worker_instance_type
  key_name               = var.worker_instance_enable_login ? aws_key_pair.worker[0].key_name : null

  block_device_mappings {
    device_name = "/dev/sdb"
    ebs {
      volume_size = 60
      volume_type = "gp3"
    }
  }

  iam_instance_profile {
    name = var.worker_instance_profile
  }

  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.worker_instance_node_name
      "kubernetes.io/cluster/${var.aws_eks_cluster_name}" = "owned"
    }
    
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              set -o xtrace

              host=$(hostname)
              if [[ $${#host} -gt 63 ]]; then
                  hostnamectl set-hostname $(hostname | cut -d "." -f 1).${local.hostname}
              fi

              # Create loop devices, this is taken from CDM code:
              # src/scripts/vmdkmount/make_loop.sh
              NUM_LOOP_DEVICES=255
              LOOP_REF="/dev/loop0"
              if [ ! -e $LOOP_REF ]; then
                  /sbin/losetup -f
              fi

              for ((i = 1; i < $NUM_LOOP_DEVICES; i++)); do
                if [ -e /dev/loop$i ]; then
                  continue;
                fi
                mknod /dev/loop$i b 7 $i;
                chown --reference=$LOOP_REF /dev/loop$i;
                chmod --reference=$LOOP_REF /dev/loop$i;
              done

              # Remove LVM on host, just to avoid any interference with containers.
              yum remove -y lvm2

              #Source the env variables before running the bootstrap.sh script
              set -a
              source /etc/environment

              # https://github.com/awslabs/amazon-eks-ami/blob/master/files/bootstrap.sh
              /etc/eks/bootstrap.sh ${var.aws_eks_cluster_name} --b64-cluster-ca ${aws_eks_cluster.rsc_exocompute.certificate_authority[0].data} --apiserver-endpoint ${aws_eks_cluster.rsc_exocompute.endpoint}
              EOF
    )
}

resource "local_sensitive_file" "worker_ssh_private_key" {
  count           = var.worker_instance_enable_login ? 1 : 0
  content         = tls_private_key.worker[0].private_key_pem
  filename        = "./worker-nodes-${data.aws_iam_account_alias.current.account_alias}-${data.aws_region.current.name}.pem"
  file_permission = "0400"
}