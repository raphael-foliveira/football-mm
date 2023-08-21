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
}

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "football-mm"
}

variable "vm_admin_username" {
  description = "Admin username for the virtual machine"
  type        = string
  default     = "admin"
}

variable "vm_admin_password" {
  description = "Admin password for the virtual machine"
  type        = string
  default     = "Admin"
}

resource "azurerm_resource_group" "football_mm" {
  name = var.resource_group_name
}

data "azurerm_resource_group" "football_mm_data" {
  name = azurerm_resource_group.football_mm.name
}

resource "azurerm_virtual_network" "main" {
  name                = "football-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.football_mm.location
  resource_group_name = azurerm_resource_group.football_mm.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.football_mm.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "football-nic"
  location            = azurerm_resource_group.football_mm.location
  resource_group_name = azurerm_resource_group.football_mm.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "football-vm"
  location              = azurerm_resource_group.football_mm.location
  resource_group_name   = azurerm_resource_group.football_mm.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = var.vm_admin_username
    admin_password = var.vm_admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}

output "resource_group_id" {
  value = azurerm_resource_group.football_mm.id
}
