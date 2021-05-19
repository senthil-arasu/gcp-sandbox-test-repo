resource "google_cloud_run_service" "default" {
  name     = "cloudrun-srv"
  location = "us-west1"
  project  = "prj-bu1-d-sample-base-8e95"

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  service     = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

//data "google_projects" "environment_projects" {
//  filter = "parent.id:${split("/", var.folder_id)[1]} name:*${var.project_suffix}* labels.application_name=${var.business_code}-sample-application labels.environment=${var.environment} lifecycleState=ACTIVE"
//}

//data "google_project" "env_project" {
//  project_id = data.google_projects.environment_projects.projects[0].project_id
//}
