## ---
## Deploy Striim
## ---

variable "striim_deb_install_url" {
    description = "URL for Striim's Debian Install package"
    type        = string
    default     = "https://striim-downloads.striim.com/Releases/4.2.0.20/striim-node-4.2.0.20-Linux.deb"
}

# Remove the defaults from the variable definitions
## ---
## SKS Config
## ---

#variable "key_store_pass" {
#  description = "Java keystore password"
#  type        = string
#  sensitive   = true
#}

#variable "sys_pass" {
#  description = "Sys password to communicate between Striim nodes (non-login user)"
#  type        = string
#  sensitive   = true
#}

#variable "admin_pass" {
#  description = "Admin user password for Striim UI and Console access"
#  type        = string
#  sensitive   = true
#}


## ---
## Basic Fields
## ---

variable "striim_cluster_name" {
  description = "Name of the cluster for the Striim License"
  type        = string
  default     = "replace_me"
}

variable "striim_company_name" {
  description = "Name of the company on the license"
  type        = string
  default     = "replace_me"
}

## ---
## License Fields
## ---

variable "ProductKey" {
  description = "Product Key for the Striim License"
  type        = string
  default     = "replace_me"
  sensitive   = true
}

# Note: The variable name is spelled correctly. 
variable "LicenceKey" {
  description = "License Key for the Striim License"
  type        = string
  default     = "replace_me"
  sensitive   = true
}

## ---
## MDR Fields
## ---

variable "MetadataDbEngine" {
  description = "Database engine being used for MDR"
  type        = string
  default     = "postgres"
}

variable "MetaDataRepositoryDBname" {
  description = "Name of the database to be used for MDR"
  type        = string
  default     = "striim"
}

## ---
## MDR Fields (Database Credentials)
## ---

#variable "MetaDataRepositoryUname" {
#  description = "Name of the user for the MDR Database"
#  type        = string
#}

#variable "MetaDataRepositoryUpass" {
#  description = "Password being used for the Striim MDR - Sensitive Variable"
#  type        = string
#  sensitive   = true
#}


variable "MetaDataRepositorySchemaName" {
  description = "Name of the schema for the MDR"
  type        = string
  default     = "striim"
}

## ---
## Interface Fields
## ---

variable "quorum_size" {
  description = "Minimum number of nodes to run striim to has Quorum"
  type        = number
  default     = 1
}