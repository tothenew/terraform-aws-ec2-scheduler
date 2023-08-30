resource "aws_cloudwatch_event_rule" "start_instances_event_rule" {
  name = "start_instances_event_rule"
  description = "Starts stopped EC2 instances"
  schedule_expression = var.schedule_expression_start
  depends_on = [aws_lambda_function.ec2_start_scheduler_lambda]
}

resource "aws_cloudwatch_event_rule" "stop_instances_event_rule" {
  name = "stop_instances_event_rule"
  description = "Stops running EC2 instances"
  schedule_expression = var.schedule_expression_stop
  depends_on = [aws_lambda_function.ec2_stop_scheduler_lambda]
}

# Event target: Associates a rule with a function to run
resource "aws_cloudwatch_event_target" "start_instances_event_target" {
  target_id = "start_instances_lambda_target"
  rule = "${aws_cloudwatch_event_rule.start_instances_event_rule.name}"
  arn = "${aws_lambda_function.ec2_start_scheduler_lambda.arn}"
}

resource "aws_cloudwatch_event_target" "stop_instances_event_target" {
  target_id = "stop_instances_lambda_target"
  rule = "${aws_cloudwatch_event_rule.stop_instances_event_rule.name}"
  arn = "${aws_lambda_function.ec2_stop_scheduler_lambda.arn}"
}

# AWS Lambda Permissions: Allow CloudWatch to execute the Lambda Functions
resource "aws_lambda_permission" "allow_cloudwatch_to_call_start_scheduler" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.ec2_start_scheduler_lambda.function_name}"
  principal = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.start_instances_event_rule.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_stop_scheduler" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.ec2_stop_scheduler_lambda.function_name}"
  principal = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.stop_instances_event_rule.arn}"
}

resource "aws_iam_role" "ec2_start_stop_scheduler" {
  name = "ec2_start_stop_scheduler"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}

resource "aws_iam_policy" "ec2_start_stop_scheduler" {
  name = "ec2_access_scheduler"
  path = "/"
  policy = "${data.aws_iam_policy_document.ec2_start_stop_scheduler.json}"
}

resource "aws_iam_role_policy_attachment" "ec2_access_scheduler" {
  role       = "${aws_iam_role.ec2_start_stop_scheduler.name}"
  policy_arn = "${aws_iam_policy.ec2_start_stop_scheduler.arn}"
}

# Lambda defined that runs the Python code with the specified IAM role
resource "aws_lambda_function" "ec2_start_scheduler_lambda" {
  filename = "${data.archive_file.start_scheduler.output_path}"
  function_name = "start_instances"
  role = "${aws_iam_role.ec2_start_stop_scheduler.arn}"
  handler = "start_instances.lambda_handler"
  runtime = "python3.7"
  timeout = 300
  source_code_hash = "${data.archive_file.start_scheduler.output_base64sha256}"

  environment {
    variables = {
      tag_key   = var.tag_key
      tag_value = var.tag_value
      region = var.region
    }
  }
}

resource "aws_lambda_function" "ec2_stop_scheduler_lambda" {
  filename = "${data.archive_file.stop_scheduler.output_path}"
  function_name = "stop_instances"
  role = "${aws_iam_role.ec2_start_stop_scheduler.arn}"
  handler = "stop_instances.lambda_handler"
  runtime = "python3.7"
  timeout = 300
  source_code_hash = "${data.archive_file.stop_scheduler.output_base64sha256}"

  environment {
    variables = {
      tag_key   = var.tag_key
      tag_value = var.tag_value
      region = var.region
    }
  }
}