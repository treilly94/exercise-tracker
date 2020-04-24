# Azure

## General
provider "azurerm" {
  version = "=2.6"
  features {}
}

resource "azurerm_resource_group" "exercise" {
  name     = "exercise-tracker"
  location = "uksouth"
}

## Storage
resource "azurerm_storage_account" "exercise" {
  name                     = "exercisetracker"
  resource_group_name      = azurerm_resource_group.exercise.name
  location                 = azurerm_resource_group.exercise.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

## Serverless
resource "azurerm_app_service_plan" "exercise" {
  name                = "exercise-tracker"
  location            = azurerm_resource_group.exercise.location
  resource_group_name = azurerm_resource_group.exercise.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "exercise" {
  name                      = "exercise-tracker"
  location                  = azurerm_resource_group.exercise.location
  resource_group_name       = azurerm_resource_group.exercise.name
  app_service_plan_id       = azurerm_app_service_plan.exercise.id
  storage_connection_string = azurerm_storage_account.exercise.primary_connection_string
}

# Cloudflare
