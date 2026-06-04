resource "rancher2_project" "project" {
  name       = var.project_name
  cluster_id = var.cluster_id

  dynamic "container_resource_limit" {
    for_each = var.container_resource_limit != null ? [var.container_resource_limit] : []
    content {
      limits_cpu      = container_resource_limit.value.limits_cpu
      limits_memory   = container_resource_limit.value.limits_memory
      requests_cpu    = container_resource_limit.value.requests_cpu
      requests_memory = container_resource_limit.value.requests_memory
    }
  }

  dynamic "resource_quota" {
    for_each = var.resource_quota != null ? [var.resource_quota] : []
    content {
      project_limit {
        limits_cpu               = resource_quota.value.project_limit.limits_cpu
        limits_memory            = resource_quota.value.project_limit.limits_memory
        requests_cpu             = resource_quota.value.project_limit.requests_cpu
        requests_memory          = resource_quota.value.project_limit.requests_memory
        pods                     = resource_quota.value.project_limit.pods
        services                 = resource_quota.value.project_limit.services
        config_maps              = resource_quota.value.project_limit.config_maps
        persistent_volume_claims = resource_quota.value.project_limit.persistent_volume_claims
        replication_controllers  = resource_quota.value.project_limit.replication_controllers
        secrets                  = resource_quota.value.project_limit.secrets
        services_load_balancers  = resource_quota.value.project_limit.services_load_balancers
        services_node_ports      = resource_quota.value.project_limit.services_node_ports
      }
      namespace_default_limit {
        limits_cpu               = resource_quota.value.namespace_default_limit.limits_cpu
        limits_memory            = resource_quota.value.namespace_default_limit.limits_memory
        requests_cpu             = resource_quota.value.namespace_default_limit.requests_cpu
        requests_memory          = resource_quota.value.namespace_default_limit.requests_memory
        pods                     = resource_quota.value.namespace_default_limit.pods
        services                 = resource_quota.value.namespace_default_limit.services
        config_maps              = resource_quota.value.namespace_default_limit.config_maps
        persistent_volume_claims = resource_quota.value.namespace_default_limit.persistent_volume_claims
        replication_controllers  = resource_quota.value.namespace_default_limit.replication_controllers
        secrets                  = resource_quota.value.namespace_default_limit.secrets
        services_load_balancers  = resource_quota.value.namespace_default_limit.services_load_balancers
        services_node_ports      = resource_quota.value.namespace_default_limit.services_node_ports
      }
    }
  }
}

resource "rancher2_project_role_template_binding" "access" {
  for_each = { for i, entry in var.access : entry.entity => entry }

  # We only want the group as the binding name, so we remove the first split in
  # case we use an entity such as keycloakoidc_group://group-name .
  name = length(split("://", each.value.entity)) > 1 ? split("://", each.value.entity)[1] : each.value.entity
  project_id = rancher2_project.project.id
  role_template_id = each.value.role_template_id
  group_principal_id = each.value.no_prefix ? each.value.entity :  "keycloakoidc_group://${each.value.entity}"
}
