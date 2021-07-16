provider "aws" {
  version = "~> 1.38.0"
  shared_credentials_file = "~/.aws/credentials"
  profile = "terraform"
}