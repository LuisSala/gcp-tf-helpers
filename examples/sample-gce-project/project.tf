locals {
  key = "value"
}

module "project" {
  source = "../../modules/project-scaffold"

  org_id             = var.org_id
  billing_account_id = var.billing_account_id
  folder_name        = "vm-testing"

  prefix       = "vmt"
  region       = "us-central1"
  project_name = "VM Test"

  auto_create_network = false

  project_services = [
    #    "iamcredentials.googleapis.com",
    #    "certificatemanager.googleapis.com",
    #    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "storage.googleapis.com",
    #    "cloudresourcemanager.googleapis.com",
    #    "container.googleapis.com",
    #    "logging.googleapis.com",
    #    "monitoring.googleapis.com",
    #    "servicenetworking.googleapis.com",
    #    "serviceusage.googleapis.com",
    #    "sourcerepo.googleapis.com",
    #    "cloudbuild.googleapis.com",
    #    "containerregistry.googleapis.com",
    #    "stackdriver.googleapis.com",
    #    "artifactregistry.googleapis.com",
  ]

  org_policies = {
    "compute.requireShieldedVm" = {
      rules = [{ enforce = false }]
    }
    "compute.requireOsLogin" = {
      rules = [{ enforce = false }]
    }
    "compute.restrictVpnPeerIPs" = {
      rules = [{ allow = { all = true } }]
    }
    "compute.vmExternalIpAccess" = {
      rules = [{ allow = { all = true } }]
    },
    "storage.uniformBucketLevelAccess" = {
      rules = [{ enforce = false }]
    }
  }

  oauth_scopes = [
    #    "https://www.googleapis.com/auth/logging.write",
    #    "https://www.googleapis.com/auth/monitoring",
    #    "https://www.googleapis.com/auth/devstorage.read_only",
    #    "https://www.googleapis.com/auth/trace.append",
    #    "https://www.googleapis.com/auth/service.management.readonly",
    #    "https://www.googleapis.com/auth/servicecontrol",
  ]

}

resource "google_compute_firewall" "default" {
  name = "fw-allow-web"
  #network = module.project.vpc.name
  network = "default"
  project = module.project.project_id

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = ["22", "80", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["web"]
  depends_on = [module.project]
}