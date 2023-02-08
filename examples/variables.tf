variable "cron_start" {
  description = "The cron schedule for the period when you want EC2 up. Times are specified in UTC."
  type        = string
}

variable "cron_stop" {
  description = "The cron schedule for the period when you want EC2 down. Times are specified in UTC."
  type        = string
}

variable "instance_id" {
  description = "Target ec2 instance you want to start/stop"
  type        = string
}
