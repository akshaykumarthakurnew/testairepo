provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-akki-westeurope-01"
  location = "westeurope"
}
