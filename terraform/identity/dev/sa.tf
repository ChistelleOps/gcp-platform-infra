resource "google_service_account" "terraform_ci" {
  project      = var.project_id
  account_id   = "terraform-ci"
  display_name = "Terraform CI GitHub Actions"
  description  = "Service account for Terraform CI/CD through GitHub OIDC"
}


data "google_project" "current" {
  project_id = var.project_id
}

resource "google_service_account_iam_member" "github_impersonation" {
  service_account_id = google_service_account.terraform_ci.name
  role               = "roles/iam.workloadIdentityUser"

  member = "principalSet://iam.googleapis.com/projects/${data.google_project.current.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github.workload_identity_pool_id}/attribute.repository_id/1436334405"
}
