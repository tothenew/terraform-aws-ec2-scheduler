provider "aws" {
  region = local.region
}

locals {
  region = "us-west-2"

  tags = {
    Environment = "prod"
    GithubRepo  = "terraform-aws-ec2-scheduler"
    GithubOrg   = "tothenew"
  }
}
module "ec2-scheduler" {
  source     = "../"
  instanceid = var.instance_id
  cron_start = var.cron_start
  cron_stop  = var.cron_stop
}
