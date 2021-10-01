variable "AWS_Region" {
  description = "The AWS region to create things in."
  default     = "us-east-2"
}

variable "AZ_Count" {
  description = "Number of AZs to cover in a given AWS region"
  default     = 2
}

variable "key_Name" {
  description = "Name of AWS key pair"
  default = "terra"
}

variable "instance_Type" {
  default     = "t2.micro"
  description = "AWS instance type"
}

variable "autoScaling_Group_Min_Size" {
  description = "Min numbers of servers in AutoScaling Group"
  default     = 2
}

variable "autoScaling_Group_Max_Size" {
  description = "Max numbers of servers in AutoScaling Group"
  default     = 2
}

variable "autoScaling_Group_Desired_Capacity" {
  description = "Desired numbers of servers in AutoScaling Group"
  default     = 2
}

variable "admin_CIDR_Ingress" {
  description = "CIDR to allow tcp/22 ingress to EC2 instance"
   default = "20.0.0.0/32"
}


variable "instance_Profile_Name" {
  description = "The AWS region to create things in"

}

variable "LB_Security_Group_Name"{
  description = "The name for the security group to create that associated with load balancer"

}

variable "ECS_Security_Group_Name"{
  description = "The name for the security group to create that associated with ECS"

}

variable "ECS_Cluster_Name"{
  description = "The name of the ecs cluster"
}

variable "ECS_Task_Definition_Family_Name"{
  description = "The family name for the ecs task definition "
}

variable "IAM_Role_Name"{
  description = "The name for the iam role to create"
}

variable "IAM_Role_Policy"{
  description = "The name for the iam role policy to create"
}

variable "IAM_Role_APP_Instance_Name"{
  description = "The name for the iam role to create that has been associated with the app-instance"
}

variable "IAM_Role_Instance_Policy"{
  description = "The name of the iam policy to create that has been associated with the instance"
}

variable "application_LB_Target_Group_Name"{
  description = "The name of the application load balancers target group to create."
}
 
variable "application_LB_name"{
  description = "The name of the application load balancer to create."
}

variable "ECS_Service_Name"{
  description = "The name for the ecs service"
}

variable "ECS_Cloudwatch_Log_Group_Name" {
 description = "The name of the cloud watch log group to create thats has been associated with ecs"
}

variable "APP_Cloudwatch_Log_Group_Name" {
 description = "The name of the cloud watch log group to create thats has been associated with app"
}

variable "autoscaling_Group_Name"{
  description = "The Name for the autoscaling group"
}
