# Striim Multi-Node Terraform Deployment with AWS and Ansible

This repository contains a **Terraform configuration** to deploy a multi-node **Striim** cluster on AWS using **EC2 instances** and an **Aurora RDS** cluster for metadata storage. Post-deployment configuration is done via **Ansible**, which includes installing Striim, configuring SKS Java keys, and setting up the metadata repository.

Sensitive data such as passwords and credentials are securely managed using **AWS Secrets Manager**, and these values are dynamically injected into the Terraform configuration.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Architecture](#architecture)
- [AWS Secrets Manager Setup](#aws-secrets-manager-setup)
- [Terraform Setup](#terraform-setup)
- [Ansible Playbooks](#ansible-playbooks)
- [Important Variables](#important-variables)
- [Running the Deployment](#running-the-deployment)
- [Outputs](#outputs)
- [Troubleshooting](#troubleshooting)

## Prerequisites

Ensure you have the following tools installed and configured:
- [Terraform](https://www.terraform.io/downloads.html) (version 1.x or later)
- [AWS CLI](https://aws.amazon.com/cli/) with credentials configured
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- AWS Secrets Manager configured with the necessary secrets (explained below)

## Architecture

The deployment creates the following resources in AWS:
- **EC2 Instances**: Multi-node Striim cluster.
- **Aurora RDS Cluster**: PostgreSQL cluster for metadata storage.
- **Security Groups**: Security groups for EC2 instances and the Aurora RDS cluster.
- **AWS Secrets Manager**: Stores sensitive data like database credentials and Striim admin passwords.

## AWS Secrets Manager Setup

Sensitive credentials for Striim and Aurora RDS are stored in **AWS Secrets Manager**. These include:
- Java Keystore password (`keystore_pass`)
- Striim sys password (`sys_pass`)
- Admin password for Striim UI (`admin_pass`)
- Aurora RDS credentials (`db_username`, `db_password`)

### Creating a Secret

You can create a secret in **AWS Secrets Manager** with the following keys:

```json
{
  "keystore_pass": "your-keystore-password",
  "sys_pass": "your-sys-password",
  "admin_pass": "your-admin-password",
  "db_username": "your-db-username",
  "db_password": "your-db-password"
}
```

Use the AWS CLI to create the secret:

```bash
aws secretsmanager create-secret --name striim-secrets \
  --secret-string '{"keystore_pass":"your-keystore-password", "sys_pass":"your-sys-password", "admin_pass":"your-admin-password", "db_username":"your-db-username", "db_password":"your-db-password"}'
```

### Accessing Secrets in Terraform

The secrets are accessed using the `data` block and decoded into variables for use in Terraform and Ansible.

## Terraform Setup

The Terraform configuration deploys:
1. **Aurora RDS Cluster** for metadata storage.
2. **EC2 Instances** for the Striim cluster.
3. **Security Groups** for the EC2 instances and Aurora RDS cluster.
4. **AWS Secrets Manager** for fetching sensitive data.

### Key Files

- **main.tf**: Configures the AWS provider and backend state.
- **vars.tf**: Defines variables such as EC2 instance counts, instance types, and security group details.
- **secrets.tf**: Fetches secrets from AWS Secrets Manager.
- **aurora-postgres.tf**: Creates the Aurora RDS cluster and its related resources.
- **ec2-compute.tf**: Provisions EC2 instances for the Striim cluster.
- **output.tf**: Outputs key information such as RDS endpoint and EC2 public IPs.

## Ansible Playbooks

Ansible playbooks are triggered post-deployment to:
1. **Install Striim** on each EC2 node.
2. **Configure Striim SKS keys** and properties using the secrets fetched from AWS Secrets Manager.
3. **Set up the Metadata Repository** on the Aurora RDS cluster.

### Key Ansible Playbooks

- `ansible/unix-striim.yml`: Installs the Striim software.
- `ansible/configure-striim.yml`: Configures SKS Java keys and sets up the cluster.
- `ansible/configure-mdr.yml`: Configures the metadata repository on the RDS cluster.

## Important Variables

### Variables in `vars.tf`

Key variables include:
- **EC2 Instance Settings**: `striim_node_count`, `instance_type`, `node_disk_size`.
- **Security Group Settings**: `allowed_source_ips` for SSH and web access.
- **Database Credentials**: Pulled dynamically from AWS Secrets Manager.
- **SSH Key Pair**: Ensure the correct SSH key is specified for accessing the EC2 instances.

### Secrets (fetched from AWS Secrets Manager via `local.striim_secrets`)

- `key_store_pass`: Keystore password for Striim.
- `sys_pass`: Password for Striim node communication.
- `admin_pass`: Admin password for Striim UI and console.

## Running the Deployment

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Validate the Configuration

```bash
terraform validate
```

### 3. Apply the Configuration

```bash
terraform apply
```

Follow the prompts to confirm the deployment. Terraform will:
- Deploy the EC2 instances and Aurora RDS cluster.
- Execute Ansible playbooks to configure Striim and the metadata repository.

## Outputs

Once deployment is successful, the following outputs will be available:
- **EC2 Public IPs**: Public IP addresses of the Striim nodes.
- **RDS Cluster Endpoint**: Endpoint of the Aurora RDS cluster.
- **Secrets ARN**: ARN of the AWS Secrets Manager secret.

## Troubleshooting

- **Invalid Subnet Error**: Verify that the `subnet_ids` used for EC2 instances are correct and belong to the same VPC.
- **Key Pair Not Found**: Ensure that the specified SSH key pair exists in your AWS account.
- **Secrets Manager Errors**: Ensure that the secrets in AWS Secrets Manager are correctly created and accessible.

You can also run Terraform with reduced parallelism for better debugging:

```bash
terraform apply -parallelism=1
```

This will slow down the deployment and make it easier to identify issues.

---

For more details or help, check the official Terraform and Ansible documentation.
