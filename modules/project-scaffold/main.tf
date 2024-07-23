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

resource "random_string" "suffix" {
  keepers = {
    project_name = var.project_name
  }
  length  = 4
  upper   = false
  lower   = true
  numeric = true
  special = false
}

resource "random_pet" "pet_name" {
  keepers = {
    project_name = var.project_name
  }
}

module "folder" {
  source = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/folder?ref=v29.0.0"
  parent = var.org_id
  name   = "${var.folder_name} ${random_pet.pet_name.id}"

  org_policies = var.org_policies
}


module "project" {
  source              = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/project?ref=v29.0.0"
  billing_account     = var.billing_account_id
  name                = random_pet.pet_name.id
  parent              = module.folder.id
  prefix              = var.prefix
  services            = var.project_services
  auto_create_network = var.auto_create_network
  # iam = {
  #   "roles/container.hostServiceAgentUser" = [
  #     "serviceAccount:${local.gke_service_account}"
  #   ]
  # }
}

resource "google_compute_project_default_network_tier" "project-tier" {
  project      = module.project.project_id
  network_tier = var.network_service_tier
}

module "vpc" {
  count  = var.auto_create_network ? 0 : 1
  source = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/net-vpc?ref=v29.0.0"

  project_id = module.project.project_id
  name       = "default"
  subnets    = [
    {
      ip_cidr_range       = "10.0.0.0/20"
      name                = "default"
      region              = var.region
      secondary_ip_ranges = {
        pods     = "172.16.0.0/20"
        services = "192.168.0.0/24"
      }
    },
  ]
}
