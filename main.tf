provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-akki-westeurope-01"
  location = "westeurope"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "akkitestvnet"
  address_space       = ["10.2.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "snet-webapp"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.2.1.0/24"]
}

resource "azurerm_app_service_plan" "service_plan" {
  name                = "testakkiaiplan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true # This is required for Linux plans

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "appservice" {
  name                = "testakkiaiapp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.service_plan.id

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  }

  site_config {
    linux_fx_version = "PYTHON|3.8" # Example runtime
    vnet_route_all_enabled = true
  }

  vnet_integration {
    subnet_id = azurerm_subnet.subnet.id
  }
}
