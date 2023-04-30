# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###############
# Outputs    ##
###############

output "ase_name" {
  value       = local.ase_name
  description = "App Service Environment name"
}

output "ase_id" {
  value       = azurerm_app_service_environment_v3.ase.id
  description = "App Service Environment id"
}

output "ase_dns_suffix" {
  value       = azurerm_app_service_environment_v3.ase.dns_suffix
  description = "App Service Environment DNS suffix"
}

output "ase_internal_inbound_ip_addresses" {
  value       = azurerm_app_service_environment_v3.ase.internal_inbound_ip_addresses
  description = "App Service Environment internal inbound IP addresses"
}

output "ase_windows_outbound_ip_addresses" {
  value       = azurerm_app_service_environment_v3.ase.windows_outbound_ip_addresses
  description = "App Service Environment Windows outbound IP addresses"
}

output "ase_linux_outbound_ip_addresses" {
  value       = azurerm_app_service_environment_v3.ase.linux_outbound_ip_addresses
  description = "App Service Environment Linux outbound IP addresses"
}