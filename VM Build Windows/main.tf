provider "azurerm" {
version = ">=2.7.0"
features {}    
}

variable prefix {}

variable location {}

resource "azurerm_resource_group" "main" {

    name = "${var.prefix}-vm-rg-win"
    location = "${var.location}"
}


resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_subnet" "main" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix      = "10.0.1.0/24"
}




resource "azurerm_network_interface" "windows" {
  name                = "${var.prefix}-windowsnic"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  ip_configuration {
    name                          = "config1"
    subnet_id                     = "${azurerm_subnet.main.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id  = "${azurerm_public_ip.windows.id}"
  }
}



resource "azurerm_windows_virtual_machine" "windows" {
  name                  = "${var.prefix}-windowsvm"
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${azurerm_network_interface.windows.id}"]
  size               = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"

  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

    source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  
}


resource "azurerm_public_ip" "windows" {
  name                = "${var.prefix}-windows-pubip"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  allocation_method   = "Static"
}



output "windows-private-ip" {
  value       = "${azurerm_network_interface.windows.private_ip_address}"
  description = "Windows Private IP Address"
}

output "windows-public-ip" {
  value       = "${azurerm_public_ip.windows.ip_address}"
  description = "Windows Public IP Address"
}



