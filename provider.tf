provider "google" {
  credentials = file("credentials/leftprazz-sgp-1d816d995bdf.json")
  project = var.project_id
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket = "gke-infra-leftprazz-sgp"
    prefix = "state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}
