resource "google_container_node_pool" "gke-infra" {
  name       = var.node_pool.name
  cluster    = google_container_cluster.gke-infra.id
  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    machine_type = var.node_pool.machine_type
    disk_size_gb = var.node_pool.disk_size_gb
    disk_type = var.node_pool.disk_type

    labels = {
      role = "general"
    }

    service_account = google_service_account.gke-infra.email
    
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    metadata = {
      ssh-keys = "${var.gke_ssh_user}:${file(var.gke_ssh_pub_key_file)}"
      }
    tags = ["http-server", "https-server"]
  }

  autoscaling {
    min_node_count = 0
    max_node_count = 1
  }
}