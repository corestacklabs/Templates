
resource "azurerm_virtual_network" "sample" {
    name                = "${var.azure_Virtual_Network_Name}"
    address_space       = "${var.address_Space}"
    location            = "${var.location}"
    resource_group_name = "${var.azure_Resource_Group}"
}

resource "azurerm_subnet" "internal" {
  name                 = "${var.azure_Subnet_Name}"
  resource_group_name  = "${var.azure_Resource_Group}"
  virtual_network_name = "${azurerm_virtual_network.sample.name}"
  address_prefixes       = "${var.address_Prefix}"
}


resource "azurerm_network_interface" "main" {
  name                = "${var.azure_Network_Interface_Name}"
  location            = "${var.location}"
  resource_group_name = "${var.azure_Resource_Group}"

  ip_configuration {
    name                          = "${var.IP_Configuration_Name}"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "${var.private_IP_Address_Allocation}"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = "${var.location}"
  resource_group_name   = "${var.azure_Resource_Group}"
  network_interface_ids = ["${azurerm_network_interface.main.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "14.04.5-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "QA"
  }
}
