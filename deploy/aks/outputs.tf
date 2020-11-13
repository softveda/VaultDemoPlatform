output "aks_fqdn" {
  value = azurerm_kubernetes_cluster.aks.fqdn
}

output "aks_client_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
}

output "aks_client_key" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.client_key
}

output "aks_cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate
}

output "aks_kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
}

output "aks_identity_principal_id" {
  value = azurerm_kubernetes_cluster.aks.identity.0.principal_id
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  value = azurerm_container_registry.acr.admin_username
}

output "acr_admin_password" {
  value = azurerm_container_registry.acr.admin_password
}
