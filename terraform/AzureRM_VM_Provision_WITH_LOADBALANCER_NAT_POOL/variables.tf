variable "azure_Resource_Group" {
  description = "The name of the existing resource group."
  default     = "TestRG"
}

variable "location"  {
  description = "The location/region where the Load Balancer is created. Changing this forces a new resource to be created."
  default     = "East US"
}

variable "azure_Public_IP_Name" {
  description = "Name in which the public ip for the Load balancer is to be created."
  default     = "PublicIPForLB"
}

variable "public_IP_Address_Allocation" {
  description = "Type of ip address to be allocated to the user.Its value is static / dynamic"
  default     = "Static"
}

variable "azure_LB_Name" {
  description = "Name used for creating loadbalancer."
  default     = "TestLoadBalancer"
}

variable "frontend_IP_Configuration_Name" {
  description = "Name in which the Frontend ip configuration for the Load balancer is to be created"
  default     = "PublicIPAddress"
}

variable "azure_LB_Backend_Address_Pool_Name" {
  description = "Name in which the backend address pool for the Load balancer is to be created"
  default     = "BackEndAddressPool"
}

variable "azure_LB_Rule_Name" {
  description = "The name for the LoadBalancer rule."
  default     = "LBRule"
}

variable "azure_LB_Rule_Protocol" {
  description = "Load Balancer Rule Protocol. Valid options are TCP and UDP"
  default     = "TCP"
}

variable "azure_LB_NAT_Rule_Protocol" {
  description = "Load Balancer Rule Protocol. Valid options are TCP and UDP"
  default     = "TCP"
}

# variable "azure_LB_NAT_rule_name" 
# {
#  description = "The name for the LoadBalancer Nat rule."
#  default     = "RDPAccess"
# }


variable "azure_LB_NAT_Pool_Name" {
  description = "The name for the LoadBalancer Nat Pool"
  default     = "SampleApplicationPool"
}

variable "azure_LB_Probe_Name" {
  description = "Name of Load balancer probe"
  default     = "ssh-running-probe"
}

variable "azure_LB_NAT_Pool_Frontend_Port_Start" {
  description = "Frontendport Start port for load Balancer Nat Pool"
  default     = 80
}

variable "azure_LB_NAT_Pool_Frontend_Port_End" {
  description = "Frontendport end port for load Balancer Nat Pool"
  default     = 81
}

variable "azure_LB_NAT_Pool_Backend_Port" {
  description = "Backendport for load Balancer Nat Pool"
  default     = 8080
}

variable "azure_LB_Rule_Frontend_Port" {
  description = "Frontendport for load Balancer Rule"
  default     = 3389
}

variable "azure_LB_Rule_Backend_Port" {
  description = "Backendport for load Balancer Rule "
  default     = 3389
}

variable "azure_LB_Probe_Port" {
  description = "Port of Name of Load balancer probe "
  default     = 22
}

# variable "azure_LB_NAT_rule_frontendport" 
# {
#  description = "Frontendport for load Balancer Rule"
#  default     = 80
# }

# variable "azure_LB_NAT_rule_backendport" 
# {
#  description = "Backendport for load Balancer Rule "
#  default     = 81
# }
