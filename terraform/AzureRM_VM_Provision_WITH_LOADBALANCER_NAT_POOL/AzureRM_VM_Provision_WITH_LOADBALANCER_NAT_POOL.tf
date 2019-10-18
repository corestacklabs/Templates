resource "azurerm_public_ip" "test"
{
  name                         = "${var.azure_Public_IP_Name}"
  location                     = "${var.location}"
  resource_group_name          = "${var.azure_Resource_Group}"
  public_ip_address_allocation = "${var.public_IP_Address_Allocation}"
}

resource "azurerm_lb" "test"
{
  name                = "${var.azure_LB_Name}"
  location            = "${var.location}"
  resource_group_name = "${var.azure_Resource_Group}"

  frontend_ip_configuration
  {
    name                 = "${var.frontend_IP_Configuration_Name}"
    public_ip_address_id = "${azurerm_public_ip.test.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "test"
{
  resource_group_name = "${var.azure_Resource_Group}"
  loadbalancer_id     = "${azurerm_lb.test.id}"
  name                = "${var.azure_LB_Backend_Address_Pool_Name}"
}

resource "azurerm_lb_rule" "test"
{
  resource_group_name            = "${var.azure_Resource_Group}"
  loadbalancer_id                = "${azurerm_lb.test.id}"
  name                           = "${var.azure_LB_Rule_Name}"
  protocol                       = "${var.azure_LB_Rule_Protocol}"
  frontend_port                  = "${var.azure_LB_Rule_Frontend_Port}"
  backend_port                   = "${var.azure_LB_Rule_Backend_Port}"
  frontend_ip_configuration_name = "${var.frontend_IP_Configuration_Name}"
}

# resource "azurerm_lb_nat_rule" "test"
# {
#  resource_group_name            = "${var.azurerm_resource_group}"
#  loadbalancer_id                = "${azurerm_lb.test.id}"
#  name                           = "${var.azurerm_lb_nat_rule_name}"
#  protocol                       = "${var.azurerm_lb_rule_protocol}"
#  frontend_port                  = "${var.azurerm_lb_nat_rule_frontendport}"
#  backend_port                   = "${var.azurerm_lb_nat_rule_backendport}"
#  frontend_ip_configuration_name = "${var.frontend_ip_configuration_name}"
# }

resource "azurerm_lb_nat_pool" "test"
{
  resource_group_name            = "${var.azure_Resource_Group}"
  loadbalancer_id                = "${azurerm_lb.test.id}"
  name                           = "${var.azure_LB_NAT_Pool_Name}"
  protocol                       = "${var.azure_LB_NAT_Rule_Protocol}"
  frontend_port_start            = "${var.azure_LB_NAT_Pool_Frontend_Port_Start}"
  frontend_port_end              = "${var.azure_LB_NAT_Pool_Frontend_Port_End}"
  backend_port                   = "${var.azure_LB_NAT_Pool_Backend_Port}"
  frontend_ip_configuration_name = "${var.frontend_IP_Configuration_Name}"
}

resource "azurerm_lb_probe" "test"
{
  resource_group_name = "${var.azure_Resource_Group}"
  loadbalancer_id     = "${azurerm_lb.test.id}"
  name                = "${var.azure_LB_Probe_Name}"
  port                = "${var.azure_LB_Probe_Port}"
}
