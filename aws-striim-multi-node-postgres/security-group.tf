# ---
# Security Group for Striim EC2 Instances
# ---
resource "aws_security_group" "striim-node" {
  name        = var.security_group_name
  vpc_id = var.vpc_id
  description = "Security group for Striim nodes"

  # Allow SSH traffic from specific IPs
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_source_ips
  }

  # Striim UI HTTP traffic (for web console access)
  ingress {
    from_port   = 9080
    to_port     = 9080
    protocol    = "tcp"
    cidr_blocks = var.allowed_source_ips
  }

  # Striim UI HTTPS traffic
  ingress {
    from_port   = 9081
    to_port     = 9081
    protocol    = "tcp"
    cidr_blocks = var.allowed_source_ips
  }

  # Self-referencing rule (for intra-cluster communication between nodes)
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# ---
# Security Group for RDS Cluster (optional if not already defined)
# ---
resource "aws_security_group" "striim-rds" {
  name        = "${var.identifier}-rds-sg"
  vpc_id = var.vpc_id
  description = "Security group for Aurora PostgreSQL cluster"

  # Ingress rule for allowing access from the EC2 instances
  ingress {
    from_port   = 5432  # PostgreSQL default port
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.striim-node.id]  # Restrict access to the EC2 instances
  }

  # Allow all outbound traffic from the RDS cluster
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}
