output "vnet_id" {
    description = "The ID of the created VNet"
    value = azurerm_virtual_network.aks_vnet.id
}

output "control_plane_subnet_id" {
    description = "The ID of the control plane subnet within the VNet"
    value = azurerm_subnet.control_plane_subnet.id
}

output "worker_node_subnet_id" {
    description = "The ID of the worker node subnet within the VNet"
    value = azurerm_subnet.worker_node_subnet.id
}

output "networking_resource_group_name" {
    description = "Name of the networking resources' resource group"
    value = azurerm_resource_group.networking.name
}

output "aks_nsg_id" {
    description = "the ID of the Network Security Group (NSG)"
    value = azurerm_network_security_group.aks_nsg.id
}