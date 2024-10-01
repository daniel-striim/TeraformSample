# ---
# Output for RDS Cluster Endpoint
# ---
output "rds_cluster_endpoint" {
  description = "Endpoint of the Aurora RDS cluster"
  value       = aws_rds_cluster.striim-mdr[*].endpoint  # Fetch all endpoints from the RDS cluster instances
}

# ---
# Output for RDS Cluster Reader Endpoint
# ---
output "rds_cluster_reader_endpoint" {
  description = "Reader endpoint of the Aurora RDS cluster"
  value       = aws_rds_cluster.striim-mdr[*].reader_endpoint  # Fetch all reader endpoints
}

# ---
# Output for RDS Cluster ARN
# ---
output "rds_cluster_arn" {
  description = "ARN of the Aurora RDS cluster"
  value       = aws_rds_cluster.striim-mdr[*].arn  # Fetch all ARNs for the RDS cluster
}

# ---
# (Optional) VPC ID Output (Uncomment if managing the VPC in this module)
# ---
# output "vpc_id" {
#   description = "ID of the VPC"
#   value       = aws_vpc.main.id
# }
