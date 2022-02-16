#This is  used to spin up a test RG / Ubuntu VM within Azure using an existing Vnet 
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


#Create Resource Group
resource "azurerm_resource_group" "resourcegroup" {
  name     = "tmp_test_env_rg"
  location = "West US 2"
}

#Attach existing Subnet
data "azurerm_subnet" "vmsubnet" {
  name                 = var.subname
  virtual_network_name = var.vnetname
  resource_group_name  = var.vnetrg
}

#Create VM using VM Module
module "vm" {
  source   = "./VMModule"
  rgname   = azurerm_resource_group.resourcegroup.name
  location = azurerm_resource_group.resourcegroup.location
  vmname   = "tmpTest"
  size     = "Standard_B1s"
  localadmin = "locadmin"
  subnetid = data.azurerm_subnet.vmsubnet.id
}
