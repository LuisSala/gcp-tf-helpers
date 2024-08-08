# Creating a GCE VM instance that launches a container requires the use of Container Optimized OS (COS).
# COS, in turn, utilizes Konlet (https://github.com/GoogleCloudPlatform/konlet) to manage containers on the VM instance
# Documentation:
# - https://cloud.google.com/compute/docs/containers/deploying-containers
# - https://cloud.google.com/container-optimized-os/docs/how-to/create-configure-instance
resource "google_compute_instance" "cos-instance" {
  project      = module.project.project_id
  name         = "cos-instance-1"
  machine_type = "n2-standard-2"
  zone         = "us-central1-a"

  # A firewall rule that allows access to port 80 targeting VM instances with a tag of "web" is required to access
  # the nginx container that will be running in this GCE VM instance.
  tags = ["web"]
  allow_stopping_for_update = true
  # Declare a boot disk that will use Container-optimized OS (COS)
  boot_disk {
    auto_delete = true
    device_name = "instance-disk-1"

    # Specify the Container-optimized OS (COS) image in the "initialize_params" block.
    initialize_params {
      image = "projects/cos-cloud/global/images/cos-stable-109-17800-147-22"
      size  = 10
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  # The instance metadata block is used to configure and launch a container.
  #
  # Specifically, we use the "gce-container-declaration" metadata attribute to pass along a manifest
  # in accordance with the API spec inferred from the Compute Engine Container Startup Agent (Konlet)
  # API source code at: https://github.com/GoogleCloudPlatform/konlet/blob/master/gce-containers-startup/types/api.go.
  #
  # In this instance, we're using the latest version of "nginx" from Docker Hub which will be accessible on port 80.
  metadata = {
    gce-container-declaration = <<EOT
spec:
  containers:
    - name: nginx
      image: nginx:latest
      stdin: false
      tty: false
  restartPolicy: Always
EOT
  }

  # Configure the network interface to use your preferred network and subnetwork
  network_interface {
    subnetwork         = module.project.vpc.0.self_link
    subnetwork_project = module.project.project_id

    access_config {
      // Leave blank to use ephemeral public IP
    }
  }
}