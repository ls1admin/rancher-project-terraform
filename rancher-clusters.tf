################################################################################
# Rancher Clusters
# Add your downstream cluster IDs here. You can find the cluster ID in the
# Rancher UI under Cluster Management, or via `rancher2_cluster` data source.
################################################################################
locals {
  cluster_id_student = "c-m-CHANGEME" # replace with your downstream cluster ID
}

#+ Projects ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Example: a project where all members of a Keycloak group are project owners
module "example-course" {
  source = "./modules/rancher-project"

  cluster_id   = local.cluster_id_student
  project_name = "example-course"

  access = [
    {
      role_template_id = "project-owner"
      entity           = "my-course-students" # Keycloak group name
    }
  ]
}

# Example: a project with an admin group and a read-only student group,
# using explicit principal IDs (no_prefix = true disables the keycloakoidc_group:// prefix)
module "example-course-with-admin" {
  source = "./modules/rancher-project"

  cluster_id   = local.cluster_id_student
  project_name = "example-course-with-admin"

  access = [
    {
      role_template_id = "project-owner"
      entity           = "my-admin-group"
    },
    {
      role_template_id = "read-only"
      entity           = "keycloakoidc_group://my-course-students"
      no_prefix        = true
    }
  ]
}
