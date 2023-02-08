variable "cron_start" {
  description = "Target ec2 instance you want to start/stop"
  type        = string
}

variable "cron_stop" {
  type = string
}

variable "instance_id" {
  type = string
}
