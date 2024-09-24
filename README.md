# Seed Control Repository

This is a Seed Control Repository specific to the onboarded workload (read: APM code). It was created by the [terraform-bns-init](https://github.com/bns-infra/terraform-bns-init) module via the [seed control repo template](https://github.com/bns-infra/twf-seed-template).


## Table of Contents

- [Overview][1]
- [Example Input][2]
- [Requirements][3]
- [Inputs][4]
- [Outputs][5]
- [Modules][6]
- [Resources][7]

## Overview

This is a control repository to allow a local application operations team the ability to centrally manage all required resources via approvied operational patterns.

## Getting Started

There are two types of 'operational model' patterns supported currently:

| Pattern | Enforcement Module | Description |
| ------- | ------------------ | ----------- |
| VCS Workflow | [bns-infra/terraform-bns-vcsworkflow](https://github.com/bns-infra/terraform-bns-vcsworkflow) | This module enforces key resource configurations adhering to the Bank approved Tenant Workflow as per the Foundational Enhancements TDD from Google. |
| Github Workflow | [bns-infra/terraform-bns-githubflow](https://github.com/bns-infra/terraform-bns-githubflow) | This module enforces key resource configurations adhering to the Bank approved Artifact Workflow as per the Foundational Enhancements TDD from Google. |

*Important:* this repository is cloud-provider agnostic and should remain so.

## VCS Workflow Instances

Creating an instance of the VCS Workflow operational model is as simple as configuring the `vcs_workflow_instances` variable within the `locals` block as follows:

```hcl
locals {
  vcs_workflow_instances = [
    greenfield : {}
  ]
}
```

This will give you the control repository (Github Enterprise), workspaces per region and environment (Terraform Cloud) and relevant WIF bindings (Google Cloud) to the project set provisioned by the parent Seed Onboarding workflow.

### Example: Instantiate with an Approved Resource Pattern

When instantiating our resource set we can ensure that our control repository is based off our a repository template associated with a key resource pattern:

```hcl
locals {
  vcs_workflow_instances = [
    simple_gce : {
       resource_pattern = "gce_with_pub_sub"
    }
  ]
}
```

Where `gce_with_pub_sub` would map to a repository template in Github Enterprise called `bns-infra/tfw-pattern-gce_with_pub_sub`.

### Example: Instantiate Multiple VCS Workflows

A key requirement was to ensure that a team wants to manage multiple resource patterns within a single project they should be able to do so:

```hcl
locals {
  vcs_workflow_instances = [
    simple_gce : {
       resource_pattern = "gce_with_pub_sub"
    }
    atlas_cluster : {
       resource_pattern = "atlas_cluster"
    }
  ]
}
```

Where `gce_with_pub_sub` and `atlas_cluster` are repository templates in Github Enterprise.

### Example: Instantiate Multiple VCS Workflows with Differing Environments and Regions

If teams are running multiple VCS workflow instances within a project we should not assume they will have the same environment set nor run in the same regions:

```hcl
locals {
  vcs_workflow_instances = [
    simple_gce : {
       resource_pattern = "gce_with_pub_sub"
       workload_context = {
         np : {
           dev: [ "northamerica-northeast1"]
           sit: [ "northamerica-northeast1"]
           uat: [ "northamerica-northeast1"]
         },
         pr : {
           prd: [ "northamerica-northeast1", "northamerica-northeast2"]
         }
      }
    }
    atlas_cluster : {
       resource_pattern = "atlas_cluster"
       workload_context = {
         np : {
           stg: [ "northamerica-northeast1"]
         },
         pr : {
           prd: [ "northamerica-northeast1", "northamerica-northeast2"]
         }
    }
  ]
}
```

Thus application operators avoid any "lock in" around environmental or regional requirements.

## GithubFlow Instances

Creating an instance of the GithubFlow operational model is as simple as configuring the `githubflow_instances` variable within the `locals` block as follows:

```hcl
locals {
  githubflow_instances = [
    repoA : {
      repository_type = "terraform_module"
      repository_name = "terraform_abc_moduleA"
    }
    repoB : {
      repository_type = "config_sync"
      repository_name = "config_sync_moduleB"
      repository_gar  = "<gar instance id>"
    }
  ]
}

This will create the repositories and ensure an authentication strategy is in place for validation and publication workflows.
```

## Example Input

Example input to module would looks as follows:

```terraform
  # -----------------------------------------------------------------------
  # All Input Variables are to be provided from the calling Seed Workspace.
  # -----------------------------------------------------------------------
  # TODO: update "ad_group" value
  ad_group  = null
  # TODO: update "gcp_wif" value
  gcp_wif  = null
  # TODO: update "tfe_ghain" value
  tfe_ghain  = null
  # TODO: update "vault_enterprise_address" value
  vault_enterprise_address  = null
  # TODO: update "vault_enterprise_auth_path" value
  vault_enterprise_auth_path  = null
  # TODO: update "vault_enterprise_binding_claim_org" value
  vault_enterprise_binding_claim_org  = null
  # TODO: update "vault_enterprise_namespace" value
  vault_enterprise_namespace  = null
  # TODO: update "workload_id" value
  workload_id  = null
```

## Requirements

No requirements.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ad_group"></a> [ad\_group](#input\_ad\_group) | The common AD group across the services in scope. | `string` | n/a | yes |
| <a name="input_gcp_wif"></a> [gcp\_wif](#input\_gcp\_wif) | The ensures project creation at the service tier with bindings to the appropriate WIF pool per service. | <pre>map(object({<br>    tfe = object({<br>      wif_service_account = string<br>      wif_project_number  = string<br>      wif_pool_id         = string<br>      wif_provider_id     = string<br>    }),<br>    ghe = optional(object({<br>      wif_service_account = string<br>      wif_project_number  = string<br>      wif_pool_id         = string<br>      wif_provider_id     = string<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_tfe_ghain"></a> [tfe\_ghain](#input\_tfe\_ghain) | The TFC Github Application Installation. | `string` | n/a | yes |
| <a name="input_vault_enterprise_address"></a> [vault\_enterprise\_address](#input\_vault\_enterprise\_address) | The TFC Vault Address. | `string` | n/a | yes |
| <a name="input_vault_enterprise_auth_path"></a> [vault\_enterprise\_auth\_path](#input\_vault\_enterprise\_auth\_path) | The TFC Vault Authentication Path. | `string` | n/a | yes |
| <a name="input_vault_enterprise_binding_claim_org"></a> [vault\_enterprise\_binding\_claim\_org](#input\_vault\_enterprise\_binding\_claim\_org) | The Terraform Enterprise organization to be used in JWT Auth Role Bindings. | `string` | n/a | yes |
| <a name="input_vault_enterprise_namespace"></a> [vault\_enterprise\_namespace](#input\_vault\_enterprise\_namespace) | The TFC Vault Namespace. | `string` | n/a | yes |
| <a name="input_workload_id"></a> [workload\_id](#input\_workload\_id) | The Application Portfolio Management (APM) Code for the workload. | `string` | n/a | yes |

## Outputs

No outputs.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_githubflow"></a> [githubflow](#module\_githubflow) | app.terraform.io/bankofnovascotia/terraform-bns-githubworkflow/bns | >= 0.0.1 |
| <a name="module_vcsworkflow"></a> [vcsworkflow](#module\_vcsworkflow) | app.terraform.io/bankofnovascotia/terraform-bns-vcsworkflow/bns | >= 0.0.1 |

## Resources

No resources.

[1]: #overview
[2]: #example-input
[3]: #requirements
[4]: #inputs
[5]: #outputs
[6]: #modules
[7]: #resources
