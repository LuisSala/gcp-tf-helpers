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

variable "project" {
  description = "Project ID"
  type        = string
}
variable "network_service_tier" {
  description = "Network Service Tier (STANDARD or PREMIUM)"
  type        = string
  default     = "PREMIUM"
}

variable "region" {
  description = "Region to deploy cluster"
  type        = string
  default     = "us-central1"
}

variable "node_locations" {
  description = "Node locations to deploy cluster"
  type        = list(string)
  default     = ["us-central1-a", "us-central1-b"]
}

variable "cpu_nodepool_instance_type" {
  description = "CPU nodepool instance type."
  type        = string
  default     = "n2-standard-2"
}

variable "cluster_name" {
  type        = string
  description = "Cluster name"
  default     = "cluster-1"
}

variable "cluster_autoscaling" {
  description = "Enable and configure limits for Node Auto-Provisioning with Cluster Autoscaler."
  type        = object({
    auto_provisioning_defaults = optional(object({
      boot_disk_kms_key = optional(string)
      image_type        = optional(string)
      oauth_scopes      = optional(list(string))
      service_account   = optional(string)
    }))
    cpu_limits = optional(object({
      min = number
      max = number
    }))
    mem_limits = optional(object({
      min = number
      max = number
    }))
  })
  default = null
}

variable "use_cloud_foundation_fabric" {
  description = "Use Cloud Foundation Fabric"
  type        = bool
  default     = true
}

variable "use_spot" {
  type    = bool
  default = true
}

variable "private_cluster_config" {
  description = "Private cluster configuration."
  type        = object({
    enable_private_endpoint = optional(bool)
    master_global_access    = optional(bool)
    peering_config          = optional(object({
      export_routes = optional(bool)
      import_routes = optional(bool)
      project_id    = optional(string)
    }))
  })
  default = null
}