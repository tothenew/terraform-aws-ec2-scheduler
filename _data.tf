data "archive_file" "start_scheduler" {
  type        = "zip"
  source_file = "${path.module}/python/start_instances.py"
  output_path = "${path.module}/python/start_instances.zip"
}

data "archive_file" "stop_scheduler" {
  type        = "zip"
  source_file = "${path.module}/python/stop_instances.py"
  output_path = "${path.module}/python/stop_instances.zip"
}

data "aws_iam_policy_document" "ec2_start_stop_scheduler" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }

  statement {
    actions = [
      "ec2:Describe*",
      "ec2:Stop*",
      "ec2:Start*",
    ]
    
    resources = ["*"]
  }
}
