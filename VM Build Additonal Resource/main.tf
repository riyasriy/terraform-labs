provider "azurerm" {

version = ">=2.7.0"    
features {}
}

variable location{

    default = "Westus2"
}

#No RG created
#No VNET created
#No Subnet Created

#Changing location, in network interface resource 
#Use command 'az network vnet list -o table' to list down vnets in your subscription 
#Use command 'az network vnet subnet list --resource-group Lab-vm-rg --vnet-name Lab-vnet -o table' to list down subnet in a vnet 



resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = var.location
  resource_group_name = "Lab-vm-rg"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "/subscriptions/f7b27d61-e31e-4f02-abb3-640f9f7e6062/resourceGroups/Lab-vm-rg/providers/Microsoft.Network/virtualNetworks/Lab-vnet/subnets/Lab-subnet"
    private_ip_address_allocation = "Dynamic"
  }
}



resource "azurerm_windows_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = "Lab-vm-rg"
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}










