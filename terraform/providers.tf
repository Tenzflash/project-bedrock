provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Project = "karatu-2025-capstone"
    }
  }
}
