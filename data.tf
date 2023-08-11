# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# remove file if not needed
data "azurerm_client_config" "current" {}

data "azurerm_subnet" "ase_subnet" {
  name                 = var.ase_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = local.resource_group_name
}

data "azurerm_virtual_network" "pe_vnet" {
  name                = var.virtual_network_name
  resource_group_name = local.resource_group_name
}

data "azurerm_app_service_environment_v3" "ase" {
  depends_on = [
    azurerm_app_service_environment_v3.ase
  ]
  name                = local.ase_name
  resource_group_name = local.resource_group_name
}

