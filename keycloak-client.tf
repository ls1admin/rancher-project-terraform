resource "keycloak_realm" "realm" {
  realm   = var.keycloak_realm
  enabled = true
}

################################################################################
# Rancher Student
################################################################################
resource "keycloak_openid_client" "rancher-student" {
  # The ID of the realm to create the client in
  realm_id  = keycloak_realm.realm.id
  client_id = "rancher-student"

  name        = "Rancher Student"
  enabled     = true
  root_url    = var.rancher2_api_url
  base_url    = var.rancher2_api_url
  web_origins = [ var.rancher2_api_url ]

  access_type           = "CONFIDENTIAL"
  standard_flow_enabled = true
  valid_redirect_uris = [
    "${var.rancher2_api_url}/verify-auth"
  ]
}

#+ Client Mapper +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
resource "keycloak_openid_group_membership_protocol_mapper" "rancher_student_groups_mapper" {
  realm_id  = keycloak_realm.realm.id
  client_id = keycloak_openid_client.rancher-student.id
  name      = "groups-mapper"

  claim_name          = "groups"
  add_to_id_token     = false
  add_to_access_token = false
  add_to_userinfo     = true
}

resource "keycloak_openid_audience_protocol_mapper" "rancher_student_client_audience" {
  realm_id  = keycloak_realm.realm.id
  client_id = keycloak_openid_client.rancher-student.id
  name      = "audience-mapper"

  included_client_audience = keycloak_openid_client.rancher-student.client_id
  add_to_access_token      = true
}

resource "keycloak_openid_group_membership_protocol_mapper" "rancher_student_groups_path" {
  realm_id  = keycloak_realm.realm.id
  client_id = keycloak_openid_client.rancher-student.id
  name      = "groups-path"

  claim_name      = "full_group_path"
  full_path       = true
  add_to_userinfo = true
}

resource "keycloak_openid_audience_protocol_mapper" "rancher_student_aud" {
  realm_id  = keycloak_realm.realm.id
  client_id = keycloak_openid_client.rancher-student.id
  name      = "add client_id to aud"

  included_client_audience = keycloak_openid_client.rancher-student.client_id
}
