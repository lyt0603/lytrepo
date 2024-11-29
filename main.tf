provider "google" {
  project = "flash-physics-368407" # GCP 프로젝트 ID
  region  = "asia-northeast3"     # 서울 리전
  credentials = var.gcp_credentials # GCP Access Key
}

resource "google_storage_bucket" "test_bucket" {
  name                        = "test-storage-bucket-${var.gcp_project_id}"
  location                    = "ASIA-NORTHEAST3"
  storage_class               = "STANDARD"
  force_destroy               = true
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30 # 30일 지난 파일 삭제
    }
  }
}
