# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#------------------------------------------------------------
# Resource Group Lock configuration - Remove if not needed 
#------------------------------------------------------------
resource "azurerm_management_lock" "ase_level_lock" {
  count = var.enable_resource_locks ? 1 : 0

  name       = "${local.ase_name}-${var.lock_level}-lock"
  scope      = data.azurerm_app_service_environment_v3.ase.id
  lock_level = var.lock_level
  notes      = "ASE '${local.ase_name}' is locked with '${var.lock_level}' level."
}