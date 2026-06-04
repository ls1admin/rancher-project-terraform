variable "keycloak_url" {
  description = "Base URL of the Keycloak instance (e.g. https://keycloak.example.com)"
  type        = string
  sensitive   = false
}

variable "keycloak_realm" {
  description = "Keycloak realm to create and manage resources in"
  type        = string
  sensitive   = false
}

variable "keycloak_client_id" {
  description = "Client ID of the Keycloak service account used by Terraform (see https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs)"
  type        = string
  sensitive   = true
}

variable "keycloak_client_secret" {
  description = "Client secret of the Keycloak service account used by Terraform"
  type        = string
  sensitive   = true
}

variable "rancher2_api_url" {
  description = "URL of the Rancher instance (e.g. https://rancher.example.com)"
  type        = string
  sensitive   = false
}

variable "rancher2_access_key" {
  description = "Rancher API access key (token-xxxxx part)"
  type        = string
  sensitive   = true
}

variable "rancher2_secret_key" {
  description = "Rancher API secret key"
  type        = string
  sensitive   = true
}

variable "rancher2_prod_api_url" {
  description = "URL of an optional second (production) Rancher instance to create a Keycloak client for. Only required when using keycloak-client.nocommit.tf."
  type        = string
  default     = null
  sensitive   = false
}
