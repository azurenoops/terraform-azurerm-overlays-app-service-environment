# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#########################
# Network configuration #
#########################
variable "virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "ase_subnet_name" {
  description = "Name of the subnet"
  type        = string
}

#########################
# ASE configuration     #
#########################
variable "ase_custom_name" {
  description = "Custom name for the ASE. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  type        = string
  default     = null
}
variable "allow_new_private_endpoint_connections" {
  description = "Allow new private endpoint connections to the ASE. Default is true."
  type        = bool
  default     = true
}