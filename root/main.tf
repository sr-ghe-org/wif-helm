locals {
  vcs_workflow_instances = [
    {
      simple_gce = {
        resource_pattern = "gce_with_pub_sub"
        workload_context = {
          np : {
            dev : ["northamerica-northeast1"]
            sit : ["northamerica-northeast1"]
            uat : ["northamerica-northeast1"]
          },
          pr : {
            prd : ["northamerica-northeast1", "northamerica-northeast2"]
          }
        }
      },
      atlas_cluster : {
        resource_pattern = "atlas_cluster"
        workload_context = {
          np : {
            stg : ["northamerica-northeast1"]
          },
          pr : {
            prd : ["northamerica-northeast1", "northamerica-northeast2"]
          }
        }
      }
    }
  ]
}

module "vcsworkflow" {
  for_each            = locals.vcsworkflow_instances
  source              = "../terraform-bns-vcsworkflow-main 2"
  version             = ">=0.0.1"
  tfe_ghain           = ""
  gcp_projects        = ""
  repository_name     = ""
  repository_template = each.value.resource_pattern
  ghe_team_id         = ""
  workload_id         = ""
  workload_context    = each.value.workload_context
  tfe_project_id      = ""
  tfe_team_id         = ""
  wif                 = ""
}



# module "githubflow" {
#   for_each = local.vcsworkflow_instances
#   source = "../terraform-bns-githubflow-main"
#   version = ">=0.0.1"
# }
