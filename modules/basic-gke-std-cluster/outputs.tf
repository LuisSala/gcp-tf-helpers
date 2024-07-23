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

# output "terraform_state_bucket" {
#   description = "Bucket for storing terraform state"
#   value       = google_storage_bucket.tf_state_bucket
# }

# output cluster name
output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = module.gke-cluster.0.name
}

output "region" {
  description = "The region in which the GKE cluster is created"
  value       = var.region
}

output "kubernetes_endpoint" {
  sensitive = true
  value     = module.gke-cluster.0.endpoint
}

output "vpc" {
  value = module.vpc
}

# output "ca_certificate" {
#   sensitive = true
#   value     = module.cluster-1.ca_certificate
# }

# output "service_account" {
#   description = "The default service account used for running nodes."
#   value       = module.gke-cluster.0.service_account
# }

output "regional_load_balancer_static_ip" {
  description = "The static IP address for the load balancer."
  value       = google_compute_address.lb_regional_static_ip
}

output "global_load_balancer_static_ip" {
  description = "The static IP address for the load balancer."
  value       = google_compute_global_address.lb_global_static_ip
}
