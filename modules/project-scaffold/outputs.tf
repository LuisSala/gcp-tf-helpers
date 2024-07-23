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

output "project" {
  description = "The newly created project"
  value       = module.project
}

output "project_id" {
  description = "The newly created project ID"
  value       = module.project.id
}

output "parent_folder" {
  description = "The newly created project ID"
  value       = module.folder.name
}

# output "terraform_state_bucket" {
#   description = "Bucket for storing terraform state"
#   value       = google_storage_bucket.tf_state_bucket
# }

output "random_id" {
  description = "Randomly generated id"
  value       = random_string.suffix.result
}

output "pet_name" {
  description = "Randomly-generated pet name"
  value       = random_pet.pet_name.id
}


output "region" {
  description = "The region in which the project is created"
  value       = var.region
}

output "vpc" {
  description = "VPC details"
  value       = module.vpc
}
