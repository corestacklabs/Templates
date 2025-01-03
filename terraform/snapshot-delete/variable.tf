variable "filter_tag_key" {
  type        = string
  description = "The key of the tag to filter EC2 instances"
}

variable "filter_tag_value" {
  type        = string
  description = "The value of the tag to filter EC2 instances"
}

variable "cutoff_days" {
  type        = number
  description = "Number of days before snapshots are considered for deletion"
}
variable "region" {
  type        = string
  description = "The AWS region to use"
  
}
