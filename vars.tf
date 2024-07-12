variable "keycloak_url" {
  type      = string
  sensitive = false
}

variable "keycloak_realm" {
  type = string
  sensitive = false
}

variable "keycloak_client_id" {
  type      = string
  sensitive = true
}

variable "keycloak_client_secret" {
  type      = string
  sensitive = true
}

variable "rancher2_api_url" {
  type      = string
  sensitive = false
}

variable "rancher2_access_key" {
  type      = string
  sensitive = true
}

variable "rancher2_secret_key" {
  type      = string
  sensitive = true
}
