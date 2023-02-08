resource "aws_cloudwatch_event_rule" "ec2_stop" {
  count               = var.enable ? 1 : 0
  name                = "ec2-scheduler-${var.instanceid}-stop"
  description         = "Stops EC2 instance on a schedule"
  schedule_expression = "cron(${var.cron_stop})"
}

resource "aws_cloudwatch_event_target" "ec2_stop" {
  count = var.enable ? 1 : 0
  arn   = "arn:aws:ssm:${data.aws_region.current.name}::automation-definition/AWS-StopEC2Instance:$DEFAULT"
  input = jsonencode(
    {
      AutomationAssumeRole = [
        aws_iam_role.ssm_automation[0].arn,
      ]
      InstanceId = [
        var.instanceid,
      ]
    }
  )
  role_arn  = aws_iam_role.event[0].arn
  rule      = aws_cloudwatch_event_rule.ec2_stop[0].name
  target_id = "ec2-scheduler-${var.instanceid}-stop"
}

resource "aws_cloudwatch_event_rule" "ec2_start" {
  count               = var.enable ? 1 : 0
  name                = "ec2-scheduler-${var.instanceid}-start"
  description         = "Starts EC2 instance on a schedule"
  schedule_expression = "cron(${var.cron_start})"
}

resource "aws_cloudwatch_event_target" "ec2_start" {
  count = var.enable ? 1 : 0
  arn   = "arn:aws:ssm:${data.aws_region.current.name}::automation-definition/AWS-StartEC2Instance:$DEFAULT"
  input = jsonencode(
    {
      AutomationAssumeRole = [
        aws_iam_role.ssm_automation[0].arn,
      ]
      InstanceId = [
        var.instanceid,
      ]
    }
  )
  role_arn  = aws_iam_role.event[0].arn
  rule      = aws_cloudwatch_event_rule.ec2_start[0].name
  target_id = "ec2-scheduler-${var.instanceid}-start"
}