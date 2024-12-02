# Terraform Provider 설정
provider "google" {
  credentials = base64decode(var.GCP_AccessKey) # Base64로 인코딩된 GCP 서비스 계정 키
  project     = "flash-physics-368407"          # GCP 프로젝트 ID
  region      = "asia-northeast3"               # GCP 서울 리전
}

# Cloud Build 트리거 생성 (GitHub 푸시 이벤트 기반)
resource "google_cloudbuild_trigger" "github_trigger" {
  name   = "github-docker-build-trigger"
  github {
    owner         = "lyt0603"                   # GitHub 사용자 이름
    name          = "lytrepo"                   # GitHub 저장소 이름
    push {
      branch = "^main$"                         # main 브랜치에서 빌드 트리거
    }
  }
  filename = "cloudbuild.yaml"                  # GitHub 저장소에 저장된 Cloud Build 파일
}

# Cloud Run 서비스 배포
resource "google_cloud_run_service" "docker_service" {
  name     = "crypto-app-service"
  location = "asia-northeast3"
  template {
    spec {
      containers {
        image = "asia-northeast3-docker.pkg.dev/flash-physics-368407/lyt-test/crypto-app:latest"
      }
    }
  }
  autogenerate_revision_name = true
  depends_on = [google_cloudbuild_trigger.github_trigger]
}

# 변수 선언
variable "GCP_AccessKey" {
  description = "Base64 encoded GCP service account key"
  type        = string
}

variable "project" {
  description = "GCP 프로젝트 ID"
  type        = string
  default     = "flash-physics-368407"
}
