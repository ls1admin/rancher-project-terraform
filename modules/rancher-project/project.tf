resource "rancher2_project" "project" {
  name = var.project_name
  cluster_id = var.cluster_id
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
