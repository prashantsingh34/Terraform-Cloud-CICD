terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
  }

}

provider "google" {
  project = var.project
  region  = var.region
}


resource "google_storage_bucket" "state-bucket" {
  name                        = "tf-8874-terraform"
  location                    = "asia-south1"
  force_destroy               = true
  uniform_bucket_level_access = true
}


resource "google_compute_instance" "default" {
  name         = "my-instance"
  machine_type = "n2-standard-2"
  zone         = "asia-south1-a"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}

data "google_compute_instance" "appserver" {
  name       = "my-instance"
  zone       = "asia-south1-a"
  depends_on = [google_compute_instance.default]
}

output "instance_name" {
  value       = google_compute_instance.default.service_account
  description = "Name of the created Compute Engine instance"
  depends_on  = [google_compute_instance.default]
}

output "instance_ip_internal" {
  value       = google_compute_instance.default.network_interface.0.network_ip
  description = "Internal IP of the created Compute Engine instance"
}


output "instance_ip_external" {
  value       = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
  description = "External IP of the created Compute Engine instance"
}