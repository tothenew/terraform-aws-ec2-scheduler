# terraform-aws-ec2-scheduler

This module deploys ec2-scheduler that starts/stops instances on specific cron schedule.

The following resources will be created:
- One lambda for starting up the instances and another for stopping the instances.
- CloudWatch Rule (EventBridge) for triggering lambda functions. 

## Usage
```
module "ec2_scheduler" {
  source = "git::https://github.com/tothenew/terraform-aws-ec2-scheduler.git"
  region = "us-east-1" # Your desired region
  schedule_expression_start = "cron(30 12 ? * MON-FRI *)" # Runs at 8am during working days,customize according to your need.
  schedule_expression_stop = "cron(30 2 ? * MON-FRI *)" # Runs at 6pm during working days,customize according to your need.
  tag_key = "ENV"
  tag_value = "non-prod"
}
```

## Authors

Module managed by [TO THE NEW Pvt. Ltd.](https://github.com/tothenew)

## License

Apache 2 Licensed. See [LICENSE](https://github.com/tothenew/terraform-aws-vpc/blob/main/LICENSE) for full details.
