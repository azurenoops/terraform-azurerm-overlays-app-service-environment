# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azurerm_network_security_group" "ase-nsg" {

  name                = local.ase_nsg_name
  location            = local.location
  resource_group_name = local.resource_group_name

  security_rule {
    name                       = "Allow-Web-traffic"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = data.azurerm_subnet.ase_subnet.address_prefixes[0]
  }
  security_rule {
    name                       = "Allow-Ftps-traffic"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["21", "990", "10001-10020"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = data.azurerm_subnet.ase_subnet.address_prefixes[0]
  }
  security_rule {
    name                       = "Allow-VS-Remote-Debugging"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["4022", "4024", "4026"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = data.azurerm_subnet.ase_subnet.address_prefixes[0]
  }
  security_rule {
    name                       = "Allow-Web-Deploy-Service"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8172"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = data.azurerm_subnet.ase_subnet.address_prefixes[0]
  }

  security_rule {
    name                       = "Allow-Azure-Storage-Traffic"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "Storage"
  }
  security_rule {
    name                       = "Allow-Azure-SQL-Traffic"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "Sql"
  }
  security_rule {
    name                       = "Allow-Azure-Key-Vault-Traffic"
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "AzureKeyVault"
  }
  tags = merge(var.add_tags, local.default_tags)
}

data "azurerm_network_security_group" "ase-nsg" {
  depends_on = [
    azurerm_network_security_group.ase-nsg
  ]
  name                = local.ase_nsg_name
  resource_group_name = local.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "ase-subnet-nsg-association" {
  subnet_id                 = data.azurerm_subnet.ase_subnet.id
  network_security_group_id = data.azurerm_network_security_group.ase-nsg.id
}
