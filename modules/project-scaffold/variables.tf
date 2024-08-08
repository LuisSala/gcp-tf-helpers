# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

variable "org_id" {
  description = "Organization ID in 'organizations/1234' format"
  type        = string
  default     = ""
}

variable "billing_account_id" {
  description = "Billing account ID."
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Project Name. (Must be unique)"
  type        = string
  default     = "prj"
}

variable "network_service_tier" {
  description = "Network Service Tier (STANDARD or PREMIUM)"
  type        = string
  default     = "PREMIUM"
}

variable "folder_name" {
  description = "Name of the folder containing the project"
  type        = string
  default     = ""
}

variable "region" {
  description = "Region to deploy cluster"
  type        = string
  default     = "us-central1"
}

variable "prefix" {
  description = "Prefix to prepend to applicable resource names/ids. Include any dashes or other delimiters."
  type        = string
  default     = ""
}

variable "auto_create_network" {
  description = "Automatically create default VPC network"
  type        = bool
  default     = false
}

variable "gcs_location" {
  description = "GCS bucket location."
  type        = string
  default     = "US"
}

variable "project_services" {
  description = "Services to enable within the project"
  type        = list(string)
  default     = []
}

variable "org_policies" {
  description = "Organization policies applied to this folder keyed by policy name."
  type = map(object({
    inherit_from_parent = optional(bool) # for list policies only.
    reset               = optional(bool)
    rules = optional(list(object({
      allow = optional(object({
        all    = optional(bool)
        values = optional(list(string))
      }))
      deny = optional(object({
        all    = optional(bool)
        values = optional(list(string))
      }))
      enforce = optional(bool) # for boolean policies only.
      condition = optional(object({
        description = optional(string)
        expression  = optional(string)
        location    = optional(string)
        title       = optional(string)
      }), {})
    })), [])
  }))
  default  = {}
  nullable = false
}


variable "oauth_scopes" {
  description = "OAuth scopes to enable within the project"
  type        = list(string)
  default     = [
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
  ]
}