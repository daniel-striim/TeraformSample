# ---
# General Variables
# ---

variable "vpc_id" {
  description = "The ID of the VPC where resources will be deployed"
  type        = string
  default     = "replace-me"
}

variable "ssh_user" {
  description = "Name of the user to allow SSH connectivity - use name created from SSH key gen"
  type        = string
  default     = "ubuntu"
}

variable "ssh_key_private" {
  description = "Location of the user's private SSH key file"
  type        = string
  default     = "Replace-me"
  sensitive   = true  # Marked as sensitive to avoid displaying in logs
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-1"
}

# ---
# AWS Credentials (Best practice: Use environment variables or IAM roles)
# ---
variable "access_key" {
  description = "AWS Access Key for programmatic access"
  type        = string
  sensitive   = true  # Marked as sensitive
}

variable "secret_key" {
  description = "AWS Secret Key for programmatic access"
  type        = string
  sensitive   = true  # Marked as sensitive
}

variable "tags" {
  description = "List of tags associated with created resources"
  type        = map(string)
  default     = {
    environment = "replace_me"
    ownername   = "replace_me"
  }
}

# ---
# EC2 Instance Variables
# ---

variable "striim_node_count" {
  description = "Number of Striim nodes to create in the cluster"
  type        = number
  default     = 1
}

variable "key_pair" {
  description = "Name of the SSH key pair for accessing EC2 instances"
  type        = string
  default     = "sales-engineering"
}

variable "instance_type" {
  description = "Type of EC2 instance for Striim node(s)"
  type        = string
  default     = "t2.xlarge"
}

variable "node_disk_size" {
  description = "Root disk size for Striim node(s) (in GB)"
  type        = number
  default     = 64
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
  default     = "terraform-striim-node"
}

# ---
# Security Group Variables
# ---

variable "security_group_name" {
  description = "Name of the security group to be created for EC2 instances"
  type        = string
  default     = "terraform-striim-sg"
}

variable "allowed_source_ips" {
  description = "List of allowed source IPs for SSH and web console access"
  type        = list(string)
  default     = ["184.83.74.131/32"]  # Update to your own IPs or ranges
}

# ---
# Database Subnet Variables
# ---

variable "db_subnet_name" {
  description = "The name of the DB subnet group"
  type        = string
  default     = "terraform-striim-subnet"
}

variable "description" {
  description = "Description of the DB subnet group"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs for the DB subnet group"
  type        = list(string)
  default     = ["replace-me", "replace-me"]
}

# ---
# Database Credentials (These variables are placeholders and no longer use default)
# ---

#variable "username" {
#  description = "Database username for Aurora PostgreSQL"
#  type        = string
#  sensitive   = true
#}

#variable "password" {
#  description = "Database password for Aurora PostgreSQL"
#  type        = string
#  sensitive   = true
#}


# ---
# Database Instance Variables
# ---

variable "create_db_instance" {
  description = "Whether to create the RDS DB instance or not"
  type        = bool
  default     = true
}

variable "identifier" {
  description = "The name of the RDS instance"
  type        = string
  default     = "terraform-striim-mdr"
}

variable "engine" {
  description = "The database engine for the Aurora cluster"
  type        = string
  default     = "aurora-postgresql"
}

variable "engine_version" {
  description = "The engine version for Aurora"
  type        = string
  default     = "14.3"
}

variable "db_name" {
  description = "Name of the database to be created"
  type        = string
  default     = "striim"
}

variable "allow_major_version_upgrade" {
  description = "Allow major version upgrades on the DB"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Auto-upgrade minor versions during maintenance"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Apply any changes immediately or during the next maintenance window"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Skip final DB snapshot on deletion"
  type        = bool
  default     = true
}

variable "final_snapshot_identifier" {
  description = "Identifier for the final snapshot before DB deletion"
  type        = string
  default     = "striim-mdr-final-snapshot"
}

variable "performance_insights_enabled" {
  description = "Enable Performance Insights for the RDS cluster"
  type        = bool
  default     = false
}

variable "performance_insights_retention_period" {
  description = "Retention period for Performance Insights data"
  type        = number
  default     = 7
}

variable "backup_retention_period" {
  description = "The number of days to retain backups for the RDS cluster"
  type        = number
  default     = null
}

variable "deletion_protection" {
  description = "Enable deletion protection for the RDS cluster"
  type        = bool
  default     = false
}

# ---
# AWS RDS Cluster Instance Variables
# ---

variable "striim_db_node_count" {
  description = "Number of DB instances in the Aurora cluster"
  type        = number
  default     = 1
}

variable "db_instance_name" {
  description = "Name of the RDS instance"
  type        = string
  default     = "striim-mdr"
}

variable "instance_class" {
  description = "The instance type for the RDS instance"
  type        = string
  default     = "db.t4g.medium"
}
