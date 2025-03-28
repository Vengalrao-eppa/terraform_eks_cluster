# Create a Terraform configuration to deploy an EKS cluster into AWS.
# This should be in a new VPC and include all other necessary resources.
# The new cluster should be designed to run up to 250 pods,
# handle a total peak memory usage of 28GB per node and be resilient to the
#failure of a single availability zone.
# The administrator should be able to use AWS services to monitor metrics and
# view the logs of both the cluster and applications running in it.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
resource "aws_key_pair" "eks_key" {
  key_name   = "mtckey"   # mtckey is the name of the key which is my existing key using the existing one
  public_key = file("/Users/vengalraoeppa/.ssh/id_rsa.pub")  # this is the path to my existing public key
}

resource "aws_eks_cluster" "eks_devops_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.public_subnet_a.id,
      aws_subnet.public_subnet_b.id,
      aws_subnet.public_subnet_c.id
    ]
  }
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  tags = { Name = var.cluster_name }
}

variable "instance_type" {
  default = ["t3.2xlarge"]
}
resource "aws_eks_node_group" "eks_nodes" {
  cluster_name  = aws_eks_cluster.eks_devops_cluster.name
  node_role_arn = aws_iam_role.node_role.arn
  subnet_ids    = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id, aws_subnet.public_subnet_c.id]

  scaling_config {
    desired_size = 3     # It will maintain 3 nodes
    max_size     = 5     # It will scale up to 5 nodes
    min_size     = 2     # It will scale down to 1 node
  }

  instance_types = var.instance_type

  launch_template {
    version = "$Latest"
    id = aws_launch_template.eks_nodes.id
  }
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9451AD2B53C7F41FAB22886CC07D482085336561"]
  url             = aws_eks_cluster.eks_devops_cluster.identity[0].oidc[0].issuer
}

resource "aws_launch_template" "eks_nodes" {
  name_prefix = "eks-node-group"
  image_id    = data.aws_ami.eks_worker.id

  user_data = base64encode(<<-EOT
    #!/bin/bash
    echo 'KUBELET_EXTRA_ARGS="--max-pods=100"' > /etc/sysconfig/kubelet
    systemctl restart kubelet
  EOT
  )
}

variable "eks_worker_ami_version" {
  description = "EKS worker AMI version"
  type        = string
  default     = "1.21" # Set a default version
}

data "aws_ssm_parameter" "eks_worker_ami" {
  name = "/aws/service/eks/optimized-ami/${var.eks_worker_ami_version}/amazon-linux-2/recommended/image_id"
}

data "aws_ami" "eks_worker" {
  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI account ID
  filter {
    name   = "image-id"
    values = [data.aws_ssm_parameter.eks_worker_ami.value]
  }
}

# The administrator should be able to use AWS services to
# monitor metrics and view the logs of both the cluster and applications running in it.
resource "aws_cloudwatch_log_group" "eks_logs" {
  name = "/aws/eks/${var.cluster_name}/logs"
}
