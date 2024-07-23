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

data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

# data "google_client_config" "default" {}

# provider "kubernetes" {
#   host                   = "https://${module.cluster-1.endpoint}"
#   token                  = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(module.cluster-1.ca_certificate)
# }

module "gke-cluster" {
  count               = var.use_cloud_foundation_fabric ? 1 : 0
  source              = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/gke-cluster-standard?ref=bb76878d0d228ad22c45e4da7fafbf82135c86b8"
  # ref=v27.0.0"
  project_id          = var.project
  name                = "gke-cluster-1"
  location            = var.region
  deletion_protection = false
  vpc_config          = {
    network                  = module.vpc.self_link
    subnetwork               = module.vpc.subnets["${var.region}/gke-cluster-subnet"].self_link
    secondary_range_names    = {} # use default names "pods" and "services"
    master_authorized_ranges = {
      internal-vms = "10.0.0.0/8",
      external     = "${chomp(data.http.myip.response_body)}/32"
    }
    #master_ipv4_cidr_block = "192.168.3.0/28"  # Necessary for private clusters
  }
  private_cluster_config = var.private_cluster_config
  enable_features        = {
    dataplane_v2        = true
    fqdn_network_policy = false # https://cloud.google.com/kubernetes-engine/docs/how-to/fqdn-network-policies
    workload_identity   = true
    gateway_api         = true
  }

  enable_addons = {
    horizontal_pod_autoscaling     = true
    gce_persistent_disk_csi_driver = true
    gcp_filestore_csi_driver       = true
    http_load_balancing            = true
    # config_connector = false
    # cloudrun = false # https://cloud.google.com/kubernetes-engine/docs/how-to/cloud-run
    # network_policy = false
    # dns_cache = false
  }

  logging_config = {
    enable_workloads_logs          = true
    enable_api_server_logs         = true
    enable_scheduler_logs          = true
    enable_controller_manager_logs = true
  }

  monitoring_config = {
    enable_api_server_metrics         = true
    enable_controller_manager_metrics = true
    enable_scheduler_metrics          = true
    # Kube state metrics collection requires Google Cloud Managed Service for Prometheus,
    # which is enabled by default.
    # enable_managed_prometheus = true  
    enable_daemonset_metrics          = true
    enable_deployment_metrics         = true
    enable_hpa_metrics                = true
    enable_pod_metrics                = true
    enable_statefulset_metrics        = true
    enable_storage_metrics            = true
  }

  labels = {
    environment = "dev"
  }
}

module "cluster-1-nodepool-1" {
  count           = var.use_cloud_foundation_fabric ? 1 : 0
  source          = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/gke-nodepool?ref=v27.0.0"
  project_id      = var.project
  cluster_name    = module.gke-cluster[0].name
  location        = var.region
  name            = "nodepool-1"
  labels          = { environment = "dev" }
  service_account = {
    create       = true
    email        = "nodepool-1" # optional
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  node_config = {
    machine_type             = "n2-standard-2"
    disk_size_gb             = 50
    disk_type                = "pd-ssd"
    ephemeral_ssd_count      = 1
    gvnic                    = true
    spot                     = var.use_spot
    shielded_instance_config = {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }
  }
  nodepool_config = {
    autoscaling = {
      max_node_count = 10
      min_node_count = 1
    }
    management = {
      auto_repair  = true
      auto_upgrade = true
    }
  }
}

# module "cluster-1" {

#   count = var.use_cloud_foundation_fabric ? 0 : 1

#   source                     = "terraform-google-modules/kubernetes-engine/google"
#   depends_on                 = [module.vpc, google_compute_project_default_network_tier.project-tier]
#   version                    = "27.0.0"
#   project_id                 = var.project
#   name                       = "cluster-1"
#   region                     = var.region
#   zones                      = var.node_locations
#   network                    = module.vpc.name
#   subnetwork                 = module.vpc.subnets["${var.region}/gke-subnet-cluster"].name
#   ip_range_pods              = "pods"
#   ip_range_services          = "services"
#   http_load_balancing        = false
#   network_policy             = false
#   horizontal_pod_autoscaling = true
#   filestore_csi_driver       = true
#   gateway_api_channel        = "CHANNEL_STANDARD"
#   logging_enabled_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
#   enable_shielded_nodes      = true

#   master_authorized_networks = [{
#     cidr_block   = "${chomp(data.http.myip.body)}/32"
#     display_name = "external"
#   }]

#   node_pools = [
#     {
#       name            = "default-node-pool"
#       autoscaling     = true
#       machine_type    = var.cpu_nodepool_instance_type
#       node_locations  = join(",", var.node_locations)
#       min_count       = 1
#       max_count       = 3
#       local_ssd_count = 0
#       spot            = false
#       disk_size_gb    = 20
#       disk_type       = "pd-standard"
#       image_type      = "COS_CONTAINERD"
#       enable_gcfs     = false
#       enable_gvnic    = false
#       auto_repair     = true
#       auto_upgrade    = true
#       #service_account    = module.project.service_account.email
#       preemptible        = false
#       initial_node_count = 1
#     },
#   ]

#   # node_pools_oauth_scopes = {
#   #   all = var.oauth_scopes
#   # }
# }


