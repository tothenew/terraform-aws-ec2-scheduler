variable "instanceid" {
  description = "EC2 instance id for schedule"
}

variable "cron_stop" {
  description = "Cron expression to define when to trigger a stop of the EC2"
}

variable "cron_start" {
  description = "Cron expression to define when to trigger a start of the EC2"
}

variable "enable" {
  default = true
}
