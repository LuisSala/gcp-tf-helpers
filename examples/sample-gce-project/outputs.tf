output "project_id" {
  description = "The newly created project ID"
  value       = module.project.project_id
}

output "bucket_name" {
  description = "The newly created bucket ID"
  value       = google_storage_bucket.default.id
}

output "external_ip" {
  value = google_compute_instance.cos-instance.network_interface[0].access_config[0].nat_ip
}

output "gce_vm_url" {
  value = "http://${google_compute_instance.cos-instance.network_interface[0].access_config[0].nat_ip}/"
}
