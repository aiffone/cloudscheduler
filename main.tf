# Grant Cloud Scheduler service account permission to invoke Compute Engine instances
resource "google_project_iam_member" "cloud_scheduler_iam" {
  project = "kayprjct01-358115"
  role    = "roles/cloudscheduler.admin"
  member  = "serviceAccount:763503286874-compute@developer.gserviceaccount.com"
}

# Grant Compute Engine default service account permission to stop and start instances
resource "google_compute_instance_iam_member" "app_engine_iam" {
  project        = "kayprjct01-358115"
  zone           = "europe-west2-c"
  instance_name  = "instance-1"
  role           = "roles/compute.instanceAdmin"
  member         = "serviceAccount:763503286874-compute@developer.gserviceaccount.com"
}

# Schedule stopping of Compute Engine instances
resource "google_cloud_scheduler_job" "stop_instances" {
  name     = "stop-instances"
  project        = "kayprjct01-358115"
  region = "europe-west2"
  schedule = "0 18 * * 1-5" # Run at 6pm on weekdays
  time_zone = "Greenwich"

  http_target {
    uri     = "https://www.googleapis.com/compute/v1/projects/${var.project_id}/zones/${var.zone}/instances/${var.instance_name}/stop"
    headers = {
      "Content-Type" = "application/json"
    }
    http_method = "POST"
  }

  #service_account_email = google_compute_engine_default_service_account.default.email
}

# Schedule starting of Compute Engine instances
resource "google_cloud_scheduler_job" "start_instances" {
  name     = "start-instances"
  project        = "kayprjct01-358115"
  region = "europe-west2"
  schedule = "0 9 * * 1-5" # Run at 9am on weekdays
  time_zone = "Greenwich"

  http_target {
    uri     = "https://www.googleapis.com/compute/v1/projects/${var.project_id}/zones/${var.zone}/instances/${var.instance_name}/start"
    headers = {
      "Content-Type" = "application/json"
    }
    http_method = "POST"
  }

  #service_account_email = google_compute_engine_default_service_account.default.email
}
