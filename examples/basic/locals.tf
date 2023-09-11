# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

locals {
  tags = {
    Project = "Azure NoOps"
    Module  = "overlays-app-service-environment"
    Toolkit = "Terraform"
    Example = "basic deployment of Azure App Service Environemt"
  }
}