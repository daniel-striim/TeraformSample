# ---
# Terraform Backend State File Configuration
# ---
terraform {
  backend "s3" {
    bucket         = "replace-me"
    key            = "replace-me"
    region         = "replace-me"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }
}

# ---
# Primary Provider Configuration
# ---
provider "aws" {
  region = var.region

  # Best practice: Use environment variables or IAM roles for credentials instead of hardcoding
  access_key = var.access_key
  secret_key = var.secret_key
}

# Optionally, use a provider alias if you're using multiple AWS accounts or regions:
# provider "aws" {
#   alias  = "replica"
#   region = "us-east-1"
# }

# ---
# Recommended Best Practice: IAM Role for AWS Authentication
# ---
# Uncomment this block if deploying within AWS infrastructure (EC2/other services) to avoid hardcoding credentials.
# provider "aws" {
#   region = var.region
#   # The AWS SDK automatically uses the IAM role assigned to the EC2 instance.
# }
