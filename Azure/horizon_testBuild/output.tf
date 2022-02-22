output "vm_id_out" {
  value = azurerm_linux_virtual_machine.hz_vm.id
}

output "priv_ip" {
value = azurerm_network_interface.netinterface.private_ip_addresses
}

output "pub_ip" {
value = azurerm_public_ip.myterraformpublicip.id
}

output "tls_private_key" {
  value     = tls_private_key.hz_ssh.private_key_pem
  sensitive = true
}