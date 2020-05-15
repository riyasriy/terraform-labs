resource "azurerm_resource_group" "core"{

name = "Core"
location = "${var.loc}"
tags     = "${var.tags}"   
}


resource "azurerm_public_ip" "PublicIP" {
  name                = "vpnGatewayPublicIp"
  location            = "azurerm_resource_group.core.location"
  resource_group_name = "azurerm_resource_group.core.name"
  allocation_method   = "Dynamic"
  tags                = "azurerm_resource_group.core.tags"

}


resource "azurerm_virtual_network" "vnet" {
  name                = "Core"
  location            = "azurerm_resource_group.core.location"
  resource_group_name = "azurerm_resource_group.core.name"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["1.1.1.1", "1.0.0.1"]

  
  subnet {
    name           = "GatewaySubnet"
    address_prefix = "10.0.0.0/24"
  }

  subnet {
    name           = "training"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "dev"
    address_prefix = "10.0.2.0/24"
    
  }

  tags = "azurerm_resource_group.core.tags"
}






#resource "azurerm_virtual_network_gateway" "vnetgw" {
#  name                = "vpnGateway"
#  location            = "azurerm_resource_group.core.location"
#  resource_group_name = "azurerm_resource_group.core.name"

# type     = "Vpn"
# vpn_type = "RouteBased"

# active_active = false
# enable_bgp    = true
# sku           = "Basic"

# ip_configuration {
# name                          = "vpnGwConfig1"
# public_ip_address_id          = "azurerm_public_ip.PublicIP.id"
# private_ip_address_allocation = "Dynamic"
# subnet_id                     = "azurerm_subnet.GatewaySubnet.id"
# }

#vpn_client_configuration {
#  address_space = ["10.2.0.0/24"]

# root_certificate {
#   name = "DigiCert-Federated-ID-Root-CA"
#  public_cert_data = <<EOF
#
# EOF

#   }

#   revoked_certificate {
#     name       = "Verizon-Global-Root-CA"
#     thumbprint = "912198EEF23DCAC40939312FEE97DD560BAE49B1"
#   }
# }
# }



