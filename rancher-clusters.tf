################################################################################
# Rancher Student
################################################################################
locals {
  cluster_id_student = "c-m-r8m7qffs" # downstream-student-ipraktikum24
}

#+ Projects ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
module "k8s-intro" {
  source = "./modules/rancher-project"

  cluster_id   = local.cluster_id_student
  project_name = "k8s-intro"

  access = [
    {
      role_template_id = "project-owner"
      entity           = "ios24-students"
    }
  ]
}

module "terraform-test-course" {
  source = "./modules/rancher-project"

  cluster_id   = local.cluster_id_student
  project_name = "terraform-test-course"

  access = [
    {
      role_template_id = "project-owner"
      entity           = "itg-admin"
    },
    {
      role_template_id = "read-only"
      entity           = "keycloakoidc_group://ios24-students"
      no_prefix        = true
    }
  ]
}
