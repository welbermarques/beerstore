terraform {
  backend "s3" {
    bucket = "terraform-hibicode-folder"
    key = "beerstore-curso-online"
    region = "us-east-1"
    profile = "terraform"
  }
}