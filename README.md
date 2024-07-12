# Terraform Rancher Projects

This Terraform / OpenTofu repository facilitates the configuration of a Rancher
instance for use in educational courses.
We configure the Keycloak and Rancher instance to support student authentication
and role mapping as well as custom user role permissions inside Rancher.

Additionally, we wrapped the project permissions into a Terraform module allowing
for easy course and project management within the Kubernetes cluster.


# Configuration

We assume that we already have a running Rancher and Keycloak instance.

## Terraform Variables

Terraform will configure everything else that we need, however we still need to
set a few variables for terraform to be able to log into Rancher and Keycloak.

For Rancher you can simply [create an API Key](https://ranchermanager.docs.rancher.com/reference-guides/user-settings/api-keys#creating-an-api-key)
for your Admin user and then provide it to Terraform as an environment variable:

```bash
export TF_VAR_rancher2_access_key=token-abcde
export TF_VAR_rancher2_secret_key=suchalongtokensuchalongtokensuchalongtokensuchalongtok
export TF_VAR_rancher2_api_url=https://rancher.example.com
```

For Keycloak the process is a bit more complicated. You will need to create a
Service Account as described on the [Keycloak Terraform page](https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs).
Then you will provide the client id and the client secret as an environment
variable for Terraform:

```bash
export TF_VAR_keycloak_client_id=client_id
export TF_VAR_keycloak_client_secret=client_secrettttttttttttttt
export TF_VAR_keycloak_url=https://keycloak.example.com
export TF_VAR_keycloak_realm=tum
```

## Creating Resources

Now terraform should be able to log into Keycloak and Rancher.

We will be importing some already exising groups from Rancher since we will edit
them in the Terraform code and thus need to import them into the terraform state
before running the code.

```bash
terraform import rancher2_global_role.rancher_student_base_role user-base
terraform import rancher2_global_role.rancher_student_standard_role user
```

Now you can just run `terraform apply` and Terraform will configure all the
global settings in Rancher and Keycloak.

## Rancher Authentication

Since the [rancher2](https://www.terraform.io/docs/providers/rancher2/)
Terraform provider [doesn't support OIDC Configuration](https://github.com/rancher/terraform-provider-rancher2/issues/749)
we need to configure this on the Rancher web interface.
Rancher has Documentation on [how to configure Keycloak (OIDC)](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/authentication-permissions-and-global-configuration/authentication-config/configure-keycloak-oidc#configuring-keycloak-in-rancher)

We don't need to configure anything in Keycloak since Terraform just did that so
you can skip directly to the "Configure Keycloak in Rancher" Section.
When configuring OIDC you will be asked to log into Keycloak with your Keycloak
account. This will link your Keycloak account as a Rancher Admin account.
You also have the option to restrict login to certain groups if you want.

# Usage

Once Terraform has finished the initial run successfully, and students can log
into rancher via Keycloak we can start creating Projects.

For this you will likely have a 2. Cluster imported in Rancher that you dedicate
to a course. Enter the ID of that cluster into the `rancher-clusters.tf` file as
a local variable since you will need it for each project.

```diff
  locals {
    cluster_id_student = "c-m-r8m7qffs" # downstream-student-ipraktikum24
+   cluster_id_newcluster = "c-m-abcdefg" # downstrea-testcluster
  }
```

Now you can simply create new Projects on demand with the terraform module, here
is an example:

```tf
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
```

- `cluster_id` is the downstream cluster that we want to create the project in.
- `project_name` is the name of the project.
- `access` is a List of entities that gain project scoped access to this
  project. Every entry in the List is an Object with:
  - `role_template_id` as the Role that the entity will assume in the Project,
    here we can also use the custom roles we created such as `project-owner-pv`.
  - `entity` is the entity we want to give project-scoped access to. By default
    this will map to Keycloak groups, so an entity of `itg-admin` will allow
    everybody access that is a member of the `itg-admin` Keycloak group.
    Internally this is prefixed with the `keycloakoidc_group://` which is why we
    give the optin to disable this prefix with `no_prefix`
  - if `no-prefix` is set to true we don't prefix your entities and you have
    control over the prefixes yourself. This is useful if you use multiple
    authentication mechanisms in your Rancher instance and want to for example
    give a local user some premissions.
