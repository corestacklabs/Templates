variable "instance_id" {
    description = "The instance id to start"
    type = string
    source= instance.list_instance
    
}
variable "region" {
    description = "The region in which the instance is located"
    type = string
}
