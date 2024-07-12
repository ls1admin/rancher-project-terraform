################################################################################
# Rancher Student
################################################################################
# TODO: Deploy client auth via Terraform
# This is not supported yet: https://github.com/rancher/terraform-provider-rancher2/issues/749
# In the meantime we deploy it via UI by adding an auth provider:
# https://access.k8s.ase.cit.tum.de/dashboard/c/local/auth/config
# We could push this as a curl request
# https://github.com/juanbrny/rancher_api_with_terraform_example/blob/main/main.tf

# resource "rancher2_auth_config_keycloak" "rancher_student_keycloak" {
#     display_name_field = "Keycloak"
#     enabled = true

#     access_mode = "required"
#     allowed_principal_ids = [
#         "keycloak_group://itg-admin"
#     ]

#     entity_id = "rancher-student"

# }

# This role needs to be imported from the default rancher. This resource changes
# it to the default role for new users
# $ tf import rancher2_global_role.rancher_student_base_role user-base
resource "rancher2_global_role" "rancher_student_base_role" {
  name             = "User Base"
  new_user_default = true
}

# Same here but we disable the default
# $ tf import rancher2_global_role.rancher_student_standard_role user
resource "rancher2_global_role" "rancher_student_standard_role" {
  name             = "User"
  new_user_default = false
}


# Custom Project owner role that gives access for creating Persistent Volumes
resource "rancher2_role_template" "project_owner_pv" {
  name         = "Project Owner PV"
  context      = "project"
  default_role = true

  rules {
    api_groups = ["ui.cattle.io"]
    resources  = ["navlinks"]
    verbs      = ["get", "list", "watch"]
  }

  rules {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["get", "list", "watch"]
  }

  rules {
    api_groups = ["management.cattle.io"]
    resources  = ["projectroletemplatebindings"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rules {
    api_groups = ["project.cattle.io"]
    resources  = ["apps"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rules {
    api_groups = ["project.cattle.io"]
    resources  = ["apprevisions"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rules {
    api_groups = ["project.cattle.io"]
    resources  = ["sourcecodeproviderconfigs"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rules {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["create"]
  }

  rules {
    api_groups = [""]
    resources  = ["persistentvolumes"]
    verbs      = ["get", "list", "watch", "create", "delete", "patch", "update"]
  }

  rules {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses"]
    verbs      = ["get", "list", "watch"]
  }

  rules {
    api_groups = ["apiregistration.k8s.io"]
    resources  = ["apiservices"]
    verbs      = ["get", "list", "watch"]
  }

  rules {
    api_groups = [""]
    resources  = ["persistentvolumeclaims"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rules {
    api_groups = ["metrics.k8s.io"]
    resources  = ["pods"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rules {
    api_groups = ["management.cattle.io"]
    resources  = ["clusterevents"]
    verbs      = ["get", "list", "watch"]
  }

  rules {
    api_groups = ["management.cattle.io"]
    resources  = ["notifiers"]
    verbs      = ["get", "list", "watch"]
  }

  rules {
    api_groups = ["management.cattle.io"]
    resources  = ["projectalertrules"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rules {
    api_groups = ["management.cattle.io"]
    resources  = ["projectalertgroups"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rules {
    api_groups = ["management.cattle.io"]
    resources  = ["projectloggings"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rules {
    api_groups = ["management.cattle.io"]
    resources  = ["clustercatalogs"]
    verbs      = ["get", "list", "watch"]
  }

  rules {
    api_groups = ["management.cattle.io"]
    resources  = ["projectcatalogs"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rules {
    api_groups = ["management.cattle.io"]
    resources  = ["projectmonitorgraphs"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rules {
    api_groups = ["management.cattle.io"]
    resources  = ["catalogtemplates"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rules {
    api_groups = ["management.cattle.io"]
    resources  = ["catalogtemplateversions"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rules {
    api_groups = ["monitoring.cattle.io"]
    resources  = ["prometheus"]
    verbs      = ["view"]
  }

  rules {
    api_groups = ["monitoring.coreos.com"]
    resources  = ["prometheuses", "prometheusrules", "servicemonitors"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rules {
    api_groups = ["networking.istio.io"]
    resources  = ["destinationrules", "envoyfilters", "gateways", "serviceentries", "sidecars", "virtualservices"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rules {
    api_groups = ["config.istio.io"]
    resources = [
      "apikeys", "authorizations", "checknothings", "circonuses", "deniers", "fluentds", "handlers", "kubernetesenvs",
      "kuberneteses", "listcheckers", "listentries", "logentries", "memquotas", "metrics", "opas", "prometheuses",
      "quotas", "quotaspecbindings", "quotaspecs", "rbacs", "reportnothings", "rules", "solarwindses", "stackdrivers",
      "statsds", "stdios"
    ]
    verbs = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rules {
    api_groups = ["authentication.istio.io"]
    resources  = ["policies"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rules {
    api_groups = ["rbac.istio.io"]
    resources  = ["rbacconfigs", "serviceroles", "servicerolebindings"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rules {
    api_groups = ["security.istio.io"]
    resources  = ["authorizationpolicies"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rules {
    api_groups = ["management.cattle.io"]
    resources  = ["projects"]
    verbs      = ["own"]
  }

  rules {
    api_groups = ["catalog.cattle.io"]
    resources  = ["clusterrepos"]
    verbs      = ["get", "list", "watch"]
  }

  rules {
    api_groups = ["catalog.cattle.io"]
    resources  = ["operations"]
    verbs      = ["get", "list", "watch"]
  }

  rules {
    api_groups = ["catalog.cattle.io"]
    resources  = ["releases"]
    verbs      = ["get", "list", "watch"]
  }

  rules {
    api_groups = ["catalog.cattle.io"]
    resources  = ["apps"]
    verbs      = ["get", "list", "watch"]
  }

  rules {
    api_groups     = ["management.cattle.io"]
    resource_names = ["local"]
    resources      = ["clusters"]
    verbs          = ["get"]
  }
}
