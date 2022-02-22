#This is  used to spin up a new Ubuntu VM in an existing RG, utilizing existing resources to install / test Horizon 
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.94.0"
    }
  }
}

#Configure the MS Azure Provider
provider "azurerm" {
  features {
    virtual_machine {
      delete_os_disk_on_deletion     = true
      skip_shutdown_and_force_delete = true
    }
  }
}


#Attach Resource Group
data "azurerm_resource_group" "resourcegroup" {
  name = var.rgname
}

#Attach existing Subnet
data "azurerm_subnet" "vmsubnet" {
  name                 = var.subname
  virtual_network_name = var.vnetname
  resource_group_name  = var.vnetrg
}

################################################################################################################


# Create public IPs
resource "azurerm_public_ip" "myterraformpublicip" {
  name                = "tmp_test_env_publicip"
  location            = var.location
  resource_group_name = var.rgname
  allocation_method   = "Dynamic"

  tags = {
    environment = "horizon_test_env"
  }
}

# Attach Network Security Group
data "azurerm_network_security_group" "myterraformnsg" {
  name                = var.sgname
  resource_group_name = var.rgname
}

#Create Network Interface
resource "azurerm_network_interface" "netinterface" {
  name                = "${var.vmname}-nic"
  location            = var.location
  resource_group_name = var.rgname

  ip_configuration {
    name                          = "internal"
    #subnet_id                     = var.subnetid
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsg" {
  network_interface_id      = azurerm_network_interface.netinterface.id
  network_security_group_id = data.azurerm_network_security_group.myterraformnsg.id
}


# Create (and display) an SSH key
resource "tls_private_key" "hz_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#output "tls_private_key" {
#  value     = tls_private_key.hz_ssh.private_key_pem
#  sensitive = true
#}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "hz_vm" {
  name                = "${var.vmname}-vm"
  location            = var.location
  resource_group_name = var.rgname
  network_interface_ids = [
    azurerm_network_interface.netinterface.id
  ]
  size = var.vmsize

  os_disk {
    name                 = "${var.vmname}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "10_04-lts"
    version   = "latest"
  }

  computer_name                   = "horizon-test-env-vm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.hz_ssh.public_key_openssh
  }

  tags = {
    environment = "horizon_test_env"
  }
}

##

