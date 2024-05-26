terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
  }
  backend "gcs" {
    bucket = "tf-8874-terraform"
  }
}

provider "google" {
  project = var.project
  region  = var.region
}


resource "google_storage_bucket" "state-bucket" {
  name                        = "tf-8874-terraform"
  location                    = "ASIA-SOUTH1"
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
  }



}
