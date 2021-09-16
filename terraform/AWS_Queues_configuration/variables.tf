variable "Account_Id" {
  default = ""
}
variable "AccessKeyId" {
  default     = ""
}

variable "BucketName" {
  default = "cfntestfile"
}

variable "SecretAccessKey" {
  default = ""
}

variable "LambdaFunctionName" { 
  default = "CSNEWalert_func"
}

variable "LambdaRoleName" {
  default = "CSNEW-alert_func_role"
}

variable "SQSPolicyName" {
  default = "CSNEW-SQS-policy"
}

variable "QueueNamePrefix" {
  default = "CSNEW-alert"
}

variable "IAMUser" {
  default = "CS-AssumeRole-User"
}

variable "APIGatewayName" {
  default = "CSNEW-alertAPI"
}

variable "AlertAPIPath" {
  default = "alerts"
}

variable "ScheduleAPIPath" {
  default = "resolve"
}

variable "ScheduleReqValidatorName" {
  default = "schedule_req_validator"
}
 
variable "DeploymentStage" {
  default = "NewStageName"
}
 
variable  "ExternalID" {
  default = "C0r3St@ck"
}

#variable "LambdaS3Bucket" {
#  default = "sqs-templates"
#}
 
variable  "LambdaS3key" {
  default = "governance_lambda.zip"
}

variable "SQSRoleName" {
  default = "CSNEW-SQS-Role"
}

variable "regions" {
  type        = set(string)
  default = ["us-east-1", "us-east-2"]
}

variable "TopicName" {
  default = "CS-SNS-NEW-TOPIC"
}

variable "LambdaPolicyName" {
  default = "CS-New-alert-policy"
}

variable "FolderPath" {
  default = "cfn-files"
}
