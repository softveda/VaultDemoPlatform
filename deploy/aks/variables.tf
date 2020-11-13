variable "tag_app" {
  default = "HashicorpDemo"
}

variable "prefix" {
  description = "The beginning part of resource names"
}

variable "location" {
  description = "The location of resources"
  default     = "westus"
}

variable "resource_group_name" {
  description = "The name of the rsource group"
}

# variable "aks_spn_password" {
#   description = "The service principal password"
# }
