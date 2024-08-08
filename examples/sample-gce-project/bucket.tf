# Create a GCS bucket called
resource "google_storage_bucket" "default" {
  name     = "bkt-${module.project.pet_name}-${module.project.random_id}"
  location = "US"
  project  = module.project.project_id
}