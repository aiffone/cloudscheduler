resource "google_compute_instance" "default" {
  name         = "sandbox"
  machine_type = "e2-medium"
  zone         = "europe-west2-c"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  // Local SSD disk
#   scratch_disk {
#     interface = "SCSI"
#   }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    email  = "763503286874-compute@developer.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }

  #depends_on = [google_compute_resource_policy.hourly.id]
}

resource "google_compute_resource_policy" "hourly" {
  name   = "gce-policy"
  region = "europe-west2"
  description = "Start and stop instances"
  instance_schedule_policy {
    vm_start_schedule {
      schedule = "0 14 * * *"
    }
    vm_stop_schedule {
      schedule = "0 16 * * *"
    }
    time_zone = "Greenwich"
  }
}
