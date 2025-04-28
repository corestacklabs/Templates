resource "null_resource" "sleep_30_minutes" {
  provisioner "local-exec" {
    command = "sleep 1800"
  }
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources-${var.unique_suffix}"
  location = "East US"
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestoracct${var.unique_suffix}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  depends_on = [null_resource.sleep_30_minutes]
}

resource "null_resource" "fake_download" {
  provisioner "local-exec" {
    command = "echo 'Downloading stuff...' && sleep 5"
  }

  depends_on = [null_resource.sleep_30_minutes]
}
