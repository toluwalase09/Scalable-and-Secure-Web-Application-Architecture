terraform {
  backend "s3" {
    bucket = "terrraform-test"
    region = "us-east-1"
  }
}