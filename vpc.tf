resource "google_compute_network" "gke-infra" {
    name                            = var.network.name
    routing_mode                    = "REGIONAL"
    auto_create_subnetworks         = false
    mtu                             = 1460
    delete_default_routes_on_create = false
    
    depends_on = [
        google_project_service.gke-infra["compute"]
        ]
}

resource "google_compute_subnetwork" "gke-infra" {
  name                     = var.network.subnetwork_name
  ip_cidr_range            = var.network.nodes_cidr_range
  region                   = var.region
  network                  = google_compute_network.gke-infra.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "${var.network.subnetwork_name}-pod-range"
    ip_cidr_range = var.network.pods_cidr_range
  }
  secondary_ip_range {
    range_name    = "${var.network.subnetwork_name}-service-range"
    ip_cidr_range = var.network.services_cidr_range
  }

  lifecycle {
    ignore_changes = [
      secondary_ip_range,
      ip_cidr_range,
    ]
  }
}


resource "google_compute_firewall" "gke-infra-allow-ssh" {
    name    = "gke-infra-allow-ssh"
    network = google_compute_network.gke-infra.name

    allow {
        protocol = "tcp"
        ports = ["22"] 
    }
    source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "gke-infra-allow-http" {
    name    = "gke-infra-allow-http"
    network = google_compute_network.gke-infra.name

    allow {
        protocol = "tcp"
        ports = ["80"] 
    }
    source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "gke-infra-allow-https" {
    name    = "gke-infra-allow-https"
    network = google_compute_network.gke-infra.name

    allow {
        protocol = "tcp"
        ports = ["443"] 
    }
    source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "gke-infra-allow-frontend" {
    name    = "gke-infra-allow-frontend"
    network = google_compute_network.gke-infra.name

    allow {
        protocol = "tcp"
        ports = ["5000"] 
    }
    source_ranges = ["0.0.0.0/0"]
}