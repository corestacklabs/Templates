output "virtual_Machine_Id" {
  value = "${azurerm_virtual_machine.main.id}"
}

output "virtual_Network_Id" {
  value = "${azurerm_virtual_network.sample.id}"
}

output "subnet_Id" {
  value = "${azurerm_subnet.internal.id}"
}

output "network_Interface_Id" {
  value = "${azurerm_network_interface.main.id}"
}