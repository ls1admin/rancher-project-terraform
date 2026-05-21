terraform {
  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "4.4.0"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "14.1.1"
    }
  }
}

provider "keycloak" {
  url           = var.keycloak_url
  client_id     = var.keycloak_client_id
  client_secret = var.keycloak_client_secret
}

provider "rancher2" {
  api_url    = var.rancher2_api_url
  access_key = var.rancher2_access_key
  secret_key = var.rancher2_secret_key
}
