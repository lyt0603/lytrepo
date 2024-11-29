# Terraform 설정
provider "google" {
  credentials = base64decode(var.GCP_AccessKey) # Base64로 인코딩된 값을 디코딩
  project     = "flash-physics-368407"          # GCP 프로젝트 ID
  region      = "asia-northeast3"               # GCP 서울 리전
}

# GCP 스토리지 버킷 생성 리소스
resource "google_storage_bucket" "test_bucket" {
  name     = "test-storage-bucket"
  location = "ASIA-NORTHEAST3"
}

#
# 변수 선언
variable "GCP_AccessKey" {
  description = "Base64 encoded GCP service account key"
  type        = string
}
