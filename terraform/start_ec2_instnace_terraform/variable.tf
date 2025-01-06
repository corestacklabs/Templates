variable "instance_id" {
    description = "The instance id to start"
    source= instance.list_instance
    
}
variable "region" {
    description = "The region in which the instance is located"
    type = string
}
