terraform {
  backend "s3" {
    bucket         = "terraform-hob-wopi-tfstate"
    key            = "wopi/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks-hob"
  }
}