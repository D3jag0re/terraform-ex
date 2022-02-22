# 
variable "subname" {
    type = string
    description = "existing subnet"
}

variable "vnetname" {
    type = string
    description = "existing vnet"
}

variable "vnetrg" {
    type = string
    description = "The name of the vnet resource group"
}
   
variable "location" {
    type = string
    description = "Azure Location"
}

variable "rgname" {
    type = string
    description = "The name of the existing resource group"
}

variable "sgname" {
    type = string
    description = "The name of the security group"
}

variable "vmsize" {
    type = string
    default = "Standard_B2s"
    description = "The instance size"
}

variable "vmname" {
    type = string
    description = "The name of the Virtual Machine"
}

#variable "subnetid" {
#    type = string
#    description = "subnet ID"
#}