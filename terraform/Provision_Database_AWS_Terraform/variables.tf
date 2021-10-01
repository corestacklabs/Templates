variable "identifier" {
  default     = "mydb-rds"
  description = "Identifier for your DB"
}

variable "storage" {
  default     = "10"
  description = "Storage size in GB"
}

variable "engine" {
  default     = "postgres"
  description = "Engine type, example values mysql, postgres"
}

variable "engine_Version" {
  description = "Engine version"

  default = {
    mysql    = "5.7.21"
    postgres = "9.6.8"
  }
}

variable "instance_Class" {
  default     = "db.t2.micro"
  description = "Instance class"
}

variable "DB_Name" {
  default     = "mydb"
  description = "db name"
}

variable "username" {
  default     = "myuser"
  description = "User name"
}

variable "region" {
  default     = "us-east-1"
  description = "specify the desired aws region"
}

variable "password" {
  description = "password, provide through your ENV variables"
}

variable "DB_Subnet_Group_Name"{
  description = "Name for the db subnet group"
}

variable "CIDR_Blocks" {
  default     = "10.0.3.0/24"
  description = "CIDR for sg"
}


variable "security_Group_Name" {
  description = "Name for the security group"
}


variable "security_Group_Tag_Name" {
  default     = "rds_sg"
  description = "Tag Name for sg"
}

variable "subnet_CIDR" {
  default     = "10.0.4.0/24"
  description = "CIDR Values for the subnet1"
}

variable "subnet1_CIDR" {
  default     = "10.0.6.0/24"
  description = "CIDR Values for the subnet2"
}

variable "Availability_Zone_1" {
  default     = "us-east-1a"
  description = "Your Az1, use AWS CLI to find your account specific"
}

variable "Availability_Zone_2" {
  default     = "us-east-1b"
  description = "Your Az2, use AWS CLI to find your account specific"
}

variable "VPC_Id" {
  description = "Your existing VPC ID"
}

variable "subnet_Name_1"{
   description = "Name of the subnet 1"
}


variable "subnet_Name_2"{
   description = "Name of the subnet 2"
}

