terraform {
  required_version = "1.13.1"
  backend "azurerm" {
    resource_group_name  = "WestEuropa-rg"
    storage_account_name = "projektdevops"
    container_name       = "remotestate"
    key                  = "dev.terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  //subscription_id = var.subscription_id
  ubscription_id = "e5187db1-f787-457e-9a50-4b69ed7433e4"
  features {}
}

resource "azurerm_resource_group" "rgname" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_service_plan" "sp" {
  name                = "projektservice"
  resource_group_name = azurerm_resource_group.rgname.name
  location            = azurerm_resource_group.rgname.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "linuxapp" {
  name                = "linuxapprey25"
  resource_group_name = azurerm_resource_group.rgname.name
  location            = azurerm_resource_group.rgname.location
  service_plan_id     = azurerm_service_plan.sp.id

  site_config {
    application_stack {
      dotnet_version = "3.1"
    }
    always_on = false
  }
  webdeploy_publish_basic_authentication_enabled = true
  identity { type = "SystemAssigned" }
}

resource "azurerm_cosmosdb_account" "example" {
  name                = "tencosmos25"
  location            = "westus2"
  resource_group_name = azurerm_resource_group.rgname.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 20
    max_staleness_prefix    = 200
  }

  geo_location {
    failover_priority = 0
    location          = "westus2"
  }

  identity { type = "SystemAssigned" }

}

# data "azurerm_cosmosdb_account" "tendata" {
#   name = azurerm_cosmosdb_account.example.name
#   resource_group_name = azurerm_resource_group.rgname.name
# }
# run

resource "azurerm_cosmosdb_sql_database" "example" {
  name                = "cosmos25rey"
  resource_group_name = azurerm_resource_group.rgname.name
  account_name        = azurerm_cosmosdb_account.example.name
}

resource "azurerm_cosmosdb_sql_container" "container" {
  name                  = "naszcontainer"
  database_name         = azurerm_cosmosdb_sql_database.example.name
  resource_group_name   = azurerm_resource_group.rgname.name
  account_name          = azurerm_cosmosdb_account.example.name
  partition_key_paths   = ["/id"]
  partition_key_version = "1"
  throughput            = 400

  # unique_key {
  #   paths = []
}

# next step is to deploy app code into to the linux web app
# next step is to build a cosmos DB to host web app DBs


output "azurerm_linux_web_app" {
  value = azurerm_linux_web_app.linuxapp.default_hostname
}
