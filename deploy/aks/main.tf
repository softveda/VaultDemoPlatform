terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.35.0"
    }
  }

  backend "azurerm" {
    features {}
  }
}

provider "azurerm" {
  features {}
}

# provider "azuread" {
# }

locals {
  tags = {
    app = var.tag_app
  }
}

data "azurerm_resource_group" "default" {
  name     = "${var.prefix}-platform-rg"
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.prefix}registry"
  resource_group_name = data.azurerm_resource_group.default.name
  location            = data.azurerm_resource_group.default.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = local.tags
}

# resource "azuread_application" "aks_spn" {
#   name = "${var.prefix}-aks-spn"
# }

# resource "azuread_service_principal" "aks_spn" {
#   application_id               = azuread_application.aks_spn.application_id
#   app_role_assignment_required = false
# }

# resource "azuread_service_principal_password" "aks_spn" {
#   service_principal_id = azuread_service_principal.aks_spn.id
#   description  = "aks client secret"
#   value                = var.aks_spn_password
#   end_date_relative    = "8760h" # 1 year

#   lifecycle {
#     ignore_changes = [
#       value,
#       end_date_relative
#     ]
#   }
# }

# resource "azurerm_role_assignment" "acr" {
#   scope                = data.azurerm_container_registry.acr.id
#   role_definition_name = "acrpull"
#   principal_id         = azuread_service_principal.aks_spn.object_id
# }


# requires Azure Provider 1.37+
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks"
  location            = data.azurerm_resource_group.default.location
  resource_group_name = data.azurerm_resource_group.default.name
  dns_prefix          = "${var.prefix}-aks-dns"
  kubernetes_version  = "1.19.0"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  # service_principal {
  #   client_id     = azuread_service_principal.aks_spn.application_id
  #   client_secret = var.aks_spn_password
  # }

  role_based_access_control {
    enabled = true
  }

  network_profile {
    network_plugin = "azure"
  }

  # addon_profile {
  #   oms_agent {
  #     enabled                    = true
  #     log_analytics_workspace_id = azurerm_log_analytics_workspace.pyp.id
  #   }
  # }

  tags = local.tags
}

resource "azurerm_role_assignment" "acr" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "acrpull"
  principal_id         = azurerm_kubernetes_cluster.aks.identity.0.principal_id
}
