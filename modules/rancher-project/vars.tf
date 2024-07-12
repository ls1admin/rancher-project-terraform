variable "cluster_id" {
  description = "ID of the rancher cluster the project should be created in"
  type = string
}

variable "project_name" {
  description = "Name of the rancher project"
  type = string
}

variable "access" {
    description = "List of Keycloak Groups and their associated roles within the project"
  type = list(object({
    role_template_id = string
    entity = string
    no_prefix = optional(bool, false)
  }))
}
