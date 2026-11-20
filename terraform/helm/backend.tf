terraform {
  backend "s3" {
    bucket = "defectdojo-eks-tfstate"
    key    = "helm/terraform.tfstate"
    region = "eu-west-2"

    use_lockfile = true
    encrypt      = true
  }
}