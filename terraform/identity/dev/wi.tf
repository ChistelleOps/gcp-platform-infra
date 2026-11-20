resource "google_iam_workload_identity_pool" "github" {
  workload_identity_pool_id = "github-actions"
  display_name              = "Github Actions Workload Identity"
  description               = "Federated identities for Github Actions CI/CD workflows"
  disabled                  = false
  mode                      = "FEDERATION_ONLY"
}

resource "google_iam_workload_identity_pool_provider" "github" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-oidc"
  display_name                       = "Github OIDC Provider"
  description                        = "GitHub Actions identity pool provider for GCP platform"
  disabled                           = false
  attribute_condition                = <<-EOT
    assertion.repository_owner_id == "241836648" &&
    assertion.repository_id == "1436334405" &&
    assertion.repository == "ChistelleOps/gcp-platform-infra"
  EOT
  attribute_mapping = {
    "google.subject"          = "assertion.sub"
    "attribute.repository"    = "assertion.repository"
    "attribute.repository_id" = "assertion.repository_id"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}
