# ---
# AWS EC2 Resource
# ---
resource "aws_instance" "striim-cluster" {
  # Number of nodes to deploy
  count           = var.striim_node_count
  ami             = data.aws_ami.latest_ubuntu.id  # Use dynamic AMI from the data source
  key_name        = var.key_pair
  instance_type   = var.instance_type
  vpc_security_group_ids = [aws_security_group.striim-node.id]
  subnet_id = element(var.subnet_ids, count.index)
  root_block_device {
    volume_size = var.node_disk_size
  }

  # Tagging the instances with appropriate metadata
  tags = merge(
    var.tags,
    {
      "Name" = "${var.instance_name}-${count.index}"
    },
  )
}

# ---
# EC2 AMI Data Source
# ---
data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical (Ubuntu) AMIs
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]  # Ubuntu 20.04
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
