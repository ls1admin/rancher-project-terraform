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

variable "container_resource_limit" {
  description = "Default resource limits and requests applied to every container in the project. All fields are optional."
  type = object({
    limits_cpu      = optional(string)
    limits_memory   = optional(string)
    requests_cpu    = optional(string)
    requests_memory = optional(string)
  })
  default = null
}

variable "resource_quota" {
  description = "Resource quotas enforced at the project level and optionally as the default per-namespace quota."
  type = object({
    project_limit = object({
      limits_cpu               = optional(string)
      limits_memory            = optional(string)
      requests_cpu             = optional(string)
      requests_memory          = optional(string)
      pods                     = optional(string)
      services                 = optional(string)
      config_maps              = optional(string)
      persistent_volume_claims = optional(string)
      replication_controllers  = optional(string)
      secrets                  = optional(string)
      services_load_balancers  = optional(string)
      services_node_ports      = optional(string)
    })
    namespace_default_limit = optional(object({
      limits_cpu               = optional(string)
      limits_memory            = optional(string)
      requests_cpu             = optional(string)
      requests_memory          = optional(string)
      pods                     = optional(string)
      services                 = optional(string)
      config_maps              = optional(string)
      persistent_volume_claims = optional(string)
      replication_controllers  = optional(string)
      secrets                  = optional(string)
      services_load_balancers  = optional(string)
      services_node_ports      = optional(string)
    }))
  })
  default = null
}
