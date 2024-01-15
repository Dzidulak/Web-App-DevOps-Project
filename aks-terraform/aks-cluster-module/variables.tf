variable "aks_cluster_name" {
    description = "Name of the azure kubernetes cluster being created"
    type        = string
}

variable "cluster_location" {
    description = "The Azure region where the AKS cluster will be deployed."
    type        = string
}

variable "dns_prefix" {
    description = "Defines DNS prefix for the AKS cluster."
    type        = string
}

variable "kubernetes_version" {
    description = "The version of Kubernetes to be used for the AKS cluster."
    type        = string
}

variable "service_principal_client_id" {
    description = "The Client ID of the service principal used for authenticating and managing the AKS cluster."
    type        = string
}

variable "service_principal_client_secret" {
    description = "The Client Secret associated with the service principal used for AKS cluster authentication."
    type        = string
}

# Input variables from the networking module
variable "resource_group_name" {
    description = "Name of the Azure Resource Group for networking resources."
    type        = string
}

variable "vnet_id" {
    description = "ID of the Virtual Network (VNet)."
    type        = string
}

variable "control_plane_subnet_id" {
    description = "ID of the control plane subnet."
    type        = string
}

variable "worker_node_subnet_id" {
    description = "ID of the worker node subnet."
    type        = string
}

variable "aks_nsg_id" {
    description = "ID of the Network Security Group (NSG) for AKS."
    type        = string
}
