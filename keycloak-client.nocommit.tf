################################################################################
# Rancher Production
################################################################################
resource "keycloak_openid_client" "rancher" {
  realm_id  = keycloak_realm.realm.id
  client_id = "rancher-prod"

  name        = "Rancher Production"
  enabled     = true
  root_url    = "${var.rancher2_prod_api_url}"
  base_url    = "${var.rancher2_prod_api_url}"
  web_origins = ["${var.rancher2_prod_api_url}"]

  access_type           = "CONFIDENTIAL"
  standard_flow_enabled = true
  valid_redirect_uris = [
    "${var.rancher2_prod_api_url}/verify-auth"
  ]
}

#+ Client Mapper +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
resource "keycloak_openid_group_membership_protocol_mapper" "groups_mapper" {
  realm_id  = keycloak_realm.realm.id
  client_id = keycloak_openid_client.rancher.id
  name      = "groups-mapper"

  claim_name          = "groups"
  add_to_id_token     = false
  add_to_access_token = false
  add_to_userinfo     = true
}

resource "keycloak_openid_audience_protocol_mapper" "client_audience" {
  realm_id  = keycloak_realm.realm.id
  client_id = keycloak_openid_client.rancher.id
  name      = "audience-mapper"

  included_client_audience = keycloak_openid_client.rancher.client_id
  add_to_access_token      = true
}

resource "keycloak_openid_group_membership_protocol_mapper" "groups_path" {
  realm_id  = keycloak_realm.realm.id
  client_id = keycloak_openid_client.rancher.id
  name      = "groups-path"

  claim_name      = "full_group_path"
  full_path       = true
  add_to_userinfo = true
}

resource "keycloak_openid_audience_protocol_mapper" "rancher_aud" {
  realm_id  = keycloak_realm.realm.id
  client_id = keycloak_openid_client.rancher.id
  name      = "add client_id to aud"

  included_client_audience = keycloak_openid_client.rancher.client_id
}
