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

