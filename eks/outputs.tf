output "eks_cluster_name" {
  value = aws_eks_cluster.eks_devops_cluster.name
}

output "eks_endpoint" {
  value = aws_eks_cluster.eks_devops_cluster.endpoint
}

output "vpc_id" {
  value = aws_vpc.eks_vpc.id
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}