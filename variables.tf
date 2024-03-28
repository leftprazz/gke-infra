variable "project_id" {
  type        = string
  description = "ID of the Google Project"

  default = "leftprazz-sgp"
}

variable "region" {
  type        = string
  description = "Default Region"
  
  default     = "asia-southeast1"
}

variable "zone" {
  type        = string
  description = "Default Zone"
  
  default     = "asia-southeast1-a"
}

variable "network" {
  type = object({
    name                = string
    subnetwork_name     = string
    nodes_cidr_range    = string
    pods_cidr_range     = string
    services_cidr_range = string
  })
  description = "value for VPC Network"

  default = {
    name                = "gke-infra-network"
    subnetwork_name     = "private"
    nodes_cidr_range    = "10.17.0.0/27"
    pods_cidr_range     = "10.27.0.0/24"
    services_cidr_range = "10.7.0.0/27"
  }
}

variable "gke-infra" {
  type        = object({
    name      = string
    regional  = bool
    zones     = list(string)
  })
  description = "value for GKE Cluster"

  default     = {
    name      = "gke-infra-cluster"
    regional  = true
    zones     = [
      "asia-southeast1-a",
      "asia-southeast1-b",
      "asia-southeast1-c",
    ]
  }
}

variable "node_pool" {
  type = object({
    name               = string
    machine_type       = string
    spot               = bool
    initial_node_count = number
    max_count          = number
    disk_size_gb       = number
    disk_type          = string
    node_count         = number
  })
  description = "value for GKE Node Pool"

  default = {
    name               = "gke-infra-node"
    machine_type       = "e2-custom-4-6144"
    spot               = true
    initial_node_count = 1
    max_count          = 2
    disk_size_gb       = 40
    node_count         = 2
    disk_type          = "pd-balanced"
  }
}

variable "service_account" {
  type = object({
    name  = string
    roles = list(string)
  })
  description = "Service Account for GKE"

  default = {
    name  = "gke-registry-sa"
    roles = [ "artifactregistry.reader" ]
  }
}

variable "services" {
  type = list(string)
  description = "List of services to enable"

  default = [
    "cloudresourcemanager",
    "compute",
    "container",
    "iam",
    "servicenetworking",
  ]
}


variable "github_repo_url" {
  type = string
  description = "URL of the GitHub repository"

  default = "https://github.com/leftprazz/gke-infra.git"
}

variable "gke_ssh_user" {
  description = "Username for SSH access to the Google Cloud instances"
  type        = string
  default     = "imprazz07"
}

variable "gke_ssh_pub_key_file" {
  description = "Path to the SSH public key file for SSH access to the Google Cloud instances"
  type        = string
  default     = "credentials/id_rsa.pub"
}