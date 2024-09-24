variable "ad_group" {
  description = "The common AD group across the services in scope."
  type        = string
  nullable    = false
}

variable "gcp_wif" {
  description = "The ensures project creation at the service tier with bindings to the appropriate WIF pool per service."
  type = map(object({
    tfe = object({
      service_account = string
      project_number  = string
      pool_id         = string
      provider_id     = string
      pool_full_name  = string
    }),
    ghe = optional(object({
      service_account = optional(string)
      project_number  = string
      pool_id         = string
      provider_id     = string
      pool_full_name  = string
    })),
  }))
  nullable = false
}

variable "tfe_ghain" {
  description = "The TFC Github Application Installation."
  type        = string
  nullable    = false
}
//vault related variabled -- ]
variable "workload_id" {
  description = "The Application Portfolio Management (APM) Code for the workload."
  type        = string
  nullable    = false
  validation {
    condition     = can(regex("^[A-Z][A-Z][A-Z][A-Z]$", var.workload_id))
    error_message = "The APM code is expected to be a 4 alphabetic (upper-case) character string."
  }
}
