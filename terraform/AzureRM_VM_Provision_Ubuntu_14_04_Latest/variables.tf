variable "azure_Resource_Group" {
  description = "The name of the existing resource group."
  default     = "TestRG"
}

variable "location" {
  description = "The location/region where the Load Balancer is created. Changing this forces a new resource to be created."
  default     = "East US"
}

variable "azure_Virtual_Network_Name" {
  description = "The name of the Virtual Network to create."
  default     = "testVirtualNetwork"
}

variable "address_Space" {
  description = "Address / IP of the Virtual Network"
  default     = ["10.0.0.0/16"]
}

variable "azure_Subnet_Name" {
  description = "The name of the Subnet under Virtual Network to create."
  default     = "Subnet1"
}

variable "address_Prefix" {
  description = "Address for the subnet under the Virtual Network"
  default     = ["10.0.2.0/24"]
}

variable "azure_Network_Interface_Name" {
  description = "The name of the Network Interface under Virtual Network to create."
  default     = "testnetworkinterface1"
}

variable "IP_Configuration_Name" {
  description = "The name for the Private internet protocol."
  default     = "testconfiguration-private-ip"
}

variable "private_IP_Address_Allocation" {
  description = "Type of ip address to be allocated to the user.Its value is static / dynamic"
  default     = "dynamic"
}

variable "prefix" {
  description = "The name of the Virtual Machine to create."
  default     = "testazure"
}
