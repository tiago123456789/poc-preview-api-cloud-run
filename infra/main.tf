terraform {
  backend "gcs" {
    bucket      = "poc-preview-api-cloud-run"
    prefix      = "terraform/state"
    credentials = "./../gcp.json"
  }
}

provider "google" {
  project = "poc-preview-api" 
  region  = "us-east4" 
  credentials = "./../gcp.json"
}

resource "google_cloud_run_v2_service" "preview_service" {
  name     = "${var.hash}"
  location = "us-east4"

  template {
      containers {
        image = "${var.docker_image}"  
        ports {
          container_port = 8080  
        }

        # Define environment variables for the container
        # env = [
        #   {
        #     name  = "ENVIRONMENT"
        #     value = "preview"  # Value for the environment variable
        #   },
        #   {
        #     name  = "VERSION"
        #     value = "v1"
        #   },
        #   {
        #     name  = "DATABASE_URL"
        #     value = "postgres://db.example.com:5432"
        #   }
        # ]
      }
  }


  deletion_protection = false
}


resource "google_cloud_run_service_iam_member" "unauthenticated" {
  service = google_cloud_run_v2_service.preview_service.name
  location = google_cloud_run_v2_service.preview_service.location
  role     = "roles/run.invoker"
  member   = "allUsers"  
}


