variable "instanceid" {
  description = "EC2 instance id for schedule"
  type        = string
}

variable "cron_stop" {
  description = "Cron expression to define when to trigger a stop of the EC2"
  type        = string
}

variable "cron_start" {
  description = "Cron expression to define when to trigger a start of the EC2"
  type        = string
}

variable "enable" {
  description = "Controls if resources should be created (it affects almost all resources)"
  default     = true
  type        = bool
}
