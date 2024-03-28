resource "google_service_account" "gke-infra" {
  account_id = var.service_account.name
}

resource "google_project_iam_member" "gke-infra" {
  project = var.project_id
  count   = length(var.service_account.roles)
  role    = "roles/${var.service_account.roles[count.index]}"
  member  = "serviceAccount:${google_service_account.gke-infra.email}"
}
