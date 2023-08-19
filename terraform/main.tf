terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.70.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration=true
}

resource "azurerm_resource_group" "football-dev" {
  name     = "football-dev"
  location = "West US"
}
