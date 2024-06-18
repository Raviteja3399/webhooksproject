terraform {
  backend "s3" {
    bucket = "eksartifacts1"
    key    = "EKS/terraform.tfstate"
    region = "us-east-2"
  }
}