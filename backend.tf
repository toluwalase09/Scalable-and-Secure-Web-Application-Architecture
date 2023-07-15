terraform {
  backend "s3" {
    bucket = "terrraform-test"
    key    = "staging"
    region = "us-east-1"
  }
}