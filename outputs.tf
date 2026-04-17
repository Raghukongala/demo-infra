output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "ecr_urls" {
  value = { for k, v in aws_ecr_repository.repos : k => v.repository_url }
}

output "vpc_id" {
  value = aws_vpc.main.id
}
