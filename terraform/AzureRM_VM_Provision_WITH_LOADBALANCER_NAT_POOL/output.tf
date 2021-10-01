output "load_Balancer_Id" {
  value = "${azurerm_lb.test.id}"
}

output "load_Balancer_Private_IP_Addresses" {
  value = "${azurerm_lb.test.private_ip_addresses}"
}

output "IP_Address" {
  value = "${azurerm_public_ip.test.ip_address}"
}

output "IP_Address_FQDN" {
  value = "${azurerm_public_ip.test.fqdn}"
}

output "LB_Backend_Address_Pool_Id" {
  value = "${azurerm_lb_backend_address_pool.test.id}"
}

output "LB_Rule_Id" {
  value = "${azurerm_lb_rule.test.id}"
}

output "LB_NAT_Pool_Id" {
  value = "${azurerm_lb_nat_pool.test.id}"
}

output "LB_Probe_Id" {
  value = "${azurerm_lb_probe.test.id}"
}