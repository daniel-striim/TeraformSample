
## Ansible Playbook to Run and install Striim
## Runs on all nodes created
resource "time_sleep" "Install_striim" {

  count = var.striim_node_count

  depends_on = [aws_instance.striim-cluster]

  create_duration = "35s"

  provisioner "local-exec" {
    command = <<-EOT
      ANSIBLE_HOST_KEY_CHECKING=False \
      ansible-playbook -u ${var.ssh_user} \
      -i '${aws_instance.striim-cluster[count.index].public_ip},' \
      -e STRIIM_DEB_URL=${var.striim_deb_install_url} \
      --private-key ${var.ssh_key_private} \
      ansible/unix-striim.yml
    EOT
  }
}

## Ansible Playbook to configure Striim SKS Java Keys, and Startup Properties File with server IPs and MDR IP 
## Runs on all nodes in the cluster
resource "time_sleep" "configure_striim" {

  count = var.striim_node_count

  depends_on = [aws_rds_cluster_instance.cluster_instances]

  create_duration = "30s"

  provisioner "local-exec" {
    command = <<-EOT
      ANSIBLE_HOST_KEY_CHECKING=False \
      ansible-playbook -u ${var.ssh_user} \
      -i '${aws_instance.striim-cluster[count.index].public_ip},' \
      --private-key ${var.ssh_key_private} \
      -e KEY_STORE_PASS=${local.striim_secrets["keystore_pass"]} \
      -e SYS_PASS=${local.striim_secrets["sys_pass"]} \
      -e ADMIN_PASS=${local.striim_secrets["admin_pass"]} \
      -e CLUSTER_NAME=${var.striim_cluster_name} \
      -e COMPANY_NAME=${var.striim_company_name} \
      -e MDR_PASS=${local.striim_secrets["db_password"]} \
      -e LICENCE_KEY=${var.LicenceKey} \
      -e PRODUCT_KEY=${var.ProductKey} \
      -e METADATA_IP='${aws_rds_cluster.striim-mdr[0].endpoint}' \
      -e METADATA_DB_ENGINE=${var.MetadataDbEngine} \
      -e METADATA_DB_NAME=${var.MetaDataRepositoryDBname} \
      -e METADATA_DB_USER=${local.striim_secrets["db_username"]} \
      -e METADATA_DB_PASS=${local.striim_secrets["db_password"]} \
      -e QUORUM_SIZE=${var.quorum_size} \
      -e SERVER_NODE_IPS=${join(",", aws_instance.striim-cluster.*.private_ip)} \
      ansible/configure-striim.yml
    EOT
  }
}


## Ansible Playbook to configure the Metadata repository
## Runs only on node[0] as the MDR only needs to be configured once
resource "time_sleep" "configure_mdr" {

  depends_on = [aws_rds_cluster_instance.cluster_instances]

  create_duration = "30s"

  provisioner "local-exec" {
    command = <<-EOT
      ANSIBLE_HOST_KEY_CHECKING=False \
      ansible-playbook -u ${var.ssh_user} \
      -i '${aws_instance.striim-cluster[0].public_ip},' \
      --private-key ${var.ssh_key_private} \
      -e METADATA_DB_PASS=${local.striim_secrets["db_password"]} \
      -e METADATA_IP='${aws_rds_cluster.striim-mdr[0].endpoint}' \
      -e METADATA_DB_USER=${local.striim_secrets["db_username"]} \
      -e METADATA_DB_NAME=${var.MetaDataRepositoryDBname} \
      -e METADATA_DB_SCHEMA=${var.MetaDataRepositorySchemaName} \
      ansible/configure-mdr.yml \
    EOT
  }
}
