terraform {
  backend "azurerm" {
    resource_group_name  = "tfresourcegroup"
    storage_account_name = "tfstorageaccounteu2"
    container_name       = "tfcontainer"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "resourceGroupAks"
  location = "East US 2"
}
resource "azurerm_container_registry" "acr" {
  name                = "myContainerRegistry"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Premium"
}
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "kubernetesCluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "dnsaks"
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D11"
  }
  identity {
    type = "SystemAssigned"
  }
}
resource "azurerm_role_assignment" "role" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}