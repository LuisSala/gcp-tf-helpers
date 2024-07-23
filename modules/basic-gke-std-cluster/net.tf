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

resource "google_compute_project_default_network_tier" "project-tier" {
  project      = var.project
  network_tier = var.network_service_tier
}

module "vpc" {
  source = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/net-vpc?ref=v27.0.0"

  project_id = var.project
  name       = "gke-cluster-vpc"
  subnets = [
    {
      ip_cidr_range = "10.3.23.0/24"
      name          = "gke-cluster-subnet"
      region        = var.region
      secondary_ip_ranges = {
        pods     = "172.16.0.0/20"
        services = "192.168.0.0/24"
      }
    },
  ]
}

resource "google_compute_address" "lb_regional_static_ip" {
  project      = var.project
  region       = var.region
  name         = "lb-regional-static-ip"
  network_tier = var.network_service_tier
}

resource "google_compute_global_address" "lb_global_static_ip" {
  project = var.project
  name    = "lb-global-static-ip"
}

module "firewalls" {
  source = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/net-vpc-firewall?ref=v27.0.0"

  project_id           = var.project
  network              = module.vpc.name
  default_rules_config = { admin_ranges = ["10.0.0.0/24"] }
  ingress_rules = {
    allow-k8s-http-https = {
      description          = "Allow HTTPS and HTTP from anywhere."
      direction            = "INGRESS"
      action               = "allow"
      sources              = []
      source_ranges        = ["0.0.0.0/0"]
      targets              = []
      use_service_accounts = false
      rules = [
        {
          protocol = "tcp",
          ports    = [443]
        },
        {
          protocol = "tcp",
          ports    = [80]
        }
      ]
      extra_attributes = {}
    }
    allow-health-check = {
      direction     = "INGRESS"
      action        = "allow"
      source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
      targets       = []
    }
  }

}
