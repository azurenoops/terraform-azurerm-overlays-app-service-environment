resource "azurerm_app_service_environment_v3" "ase" {
  timeouts {
    create = "300m"
    update = "60m"
    delete = "120m"
  }
  name                                   = local.ase_name
  resource_group_name                    = local.resource_group_name
  subnet_id                              = data.azurerm_subnet.ase_subnet.id
  allow_new_private_endpoint_connections = var.allow_new_private_endpoint_connections
  internal_load_balancing_mode           = "Web, Publishing"

  cluster_setting {
    name  = "DisableTls1.0"
    value = "1"
  }

  cluster_setting {
    name  = "InternalEncryption"
    value = "true"
  }

  cluster_setting {
    name  = "FrontEndSSLCipherSuiteOrder"
    value = "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
  }

  tags = merge(var.add_tags, local.default_tags)
}
resource "azurerm_private_dns_zone" "ase_dns_zone" {
  depends_on = [
    azurerm_app_service_environment_v3.ase
  ]
  name                = var.environment == "public" ? "${local.ase_name}.appserviceenvironment.net" : "${local.ase_name}.appserviceenvironment.us"
  resource_group_name = local.resource_group_name
  tags                = merge({ "Name" = format("%s", "Azure-ASE-Private-DNS-Zone") }, var.add_tags, )
}
resource "azurerm_private_dns_zone_virtual_network_link" "ase_vnet_link" {
  depends_on = [
    azurerm_private_dns_zone.ase_dns_zone
  ]
  name                  = "ase-vnet-private-zone-link"
  resource_group_name   = local.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.ase_dns_zone.name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
  registration_enabled  = false
  tags                  = merge({ "Name" = format("%s", "Azure-ASE-Private-DNS-Zone") }, var.add_tags, )
}
resource "azurerm_private_dns_a_record" "ase_wildcard_a_rec" {
  depends_on = [
    azurerm_app_service_environment_v3.ase
  ]
  name                = "*"
  zone_name           = azurerm_private_dns_zone.ase_dns_zone.name
  resource_group_name = local.resource_group_name
  ttl                 = 300
  records             = [data.azurerm_app_service_environment_v3.ase.internal_inbound_ip_addresses[0]]
}
resource "azurerm_private_dns_a_record" "ase_at_a_rec" {
  depends_on = [
    azurerm_app_service_environment_v3.ase
  ]
  name                = "@"
  zone_name           = azurerm_private_dns_zone.ase_dns_zone.name
  resource_group_name = local.resource_group_name
  ttl                 = 300
  records             = [data.azurerm_app_service_environment_v3.ase.internal_inbound_ip_addresses[0]]
}
resource "azurerm_private_dns_a_record" "ase_scm_a_rec" {
  depends_on = [
    azurerm_app_service_environment_v3.ase
  ]
  name                = "*.scm"
  zone_name           = azurerm_private_dns_zone.ase_dns_zone.name
  resource_group_name = local.resource_group_name
  ttl                 = 300
  records             = [data.azurerm_app_service_environment_v3.ase.internal_inbound_ip_addresses[0]]
}
