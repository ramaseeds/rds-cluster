provider "aws" {
  alias  = "primary"
  region = "us-east-2" # Primary region
}

provider "aws" {
  alias  = "replica"
  region = "us-west-2" # Replica region
}