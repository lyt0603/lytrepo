provider "google" {
  credentials = base64decode(var.GCP_AccessKey) # Base64로 인코딩된 값을 디코딩
  project     = "flash-physics-368407"          # GCP 프로젝트 ID
  region      = "asia-northeast3"               # GCP 서울 리전
}

resource "google_storage_bucket" "test_bucket" {
  name                       = "testbucket4235"    # 버킷 이름
  location                   = "ASIA"             # GCP 리전
  project                    = "flash-physics-368407" # 명시적 프로젝트 ID
  storage_class              = "STANDARD"         # 스토리지 클래스
  bucket_policy_only         = true              # 버킷 정책만 허용 여부
  default_event_based_hold   = false              # 이벤트 기반 기본 보류
  force_destroy              = true              # 삭제 시 버킷 내용 강제 삭제 여부
  requester_pays             = false              # 요청자 지불 활성화 여부
}

variable "GCP_AccessKey" {
  description = "Base64 encoded GCP service account key"
  type        = string
}
