terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }
}

provider "aws" {
  region  = "us-west-2"
  profile = "staging"
}
