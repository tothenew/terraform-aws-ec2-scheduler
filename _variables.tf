variable "region" {
  description = "The AWS region in which resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "schedule_expression_start"{
  type = string
  default = "cron(0 8 ? * MON-FRI *)"  
}

variable "schedule_expression_stop"{
  type = string
  default = "cron(0 18 ? * MON-FRI *)" 
}

variable "tag_key" {
  description = "The tag key to identify instances"
  type = string
}

variable "tag_value" {
  description = "The tag value to identify instances"
  type = string
}
