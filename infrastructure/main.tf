terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfresourcegroup"
    storage_account_name = "tfstorageaccountue2"
    container_name       = "tfcontainer"
    key                  = "terraform.tfstate"
  }
}
resource "azurerm_resource_group" "rg" {
  name     = "resourceGroupAks"
  location = "West Europe"
}
resource "azurerm_container_registry" "acr" {
  name                = "containerRegistry"
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
    vm_size    = "Standard_D2_v2"
  }
  identity {
    type = "SystemAssigned"
  }
}
resource "azurerm_role_assignment" "example" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}