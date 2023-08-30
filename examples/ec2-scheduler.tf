module "ec2_scheduler" {
  source = "git::https://github.com/tothenew/terraform-aws-ec2-scheduler.git"
  region = "us-east-1"
  schedule_expression_start = "cron(30 12 ? * MON-FRI *)" # Runs at 8am during working days
  schedule_expression_stop = "cron(30 2 ? * MON-FRI *)" # Runs at 6pm during working days
  tag_key = "ENV"
  tag_value = "non-prod"
}
