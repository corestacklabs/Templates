variable "TrustedAWSAccountID" {
  default = "521663498212"
}
variable "AccessKey" {
  default     = ""
}

variable "BucketName" {
  default = "cfntestfile"
}

variable "SecretAccessKey" {
  default = ""
}

variable "LambdaFunctionName" { 
  default = "CS-Testalert_func"
}

variable "LambdaRoleName" {
  default = "CS-Test-alert_func_role"
}

variable "SQSPolicyName" {
  default = "CS-Test-SQS-policy"
}

variable "QueueNamePrefix" {
  default = "CS-Test-alert"
}

#variable "QueueMessageRetentionPeriod" {
#  default = "259200"
#}

variable "APIGatewayName" {
  default = "CS-Test-alertAPI"
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
 
variable  "ExternalId" {
  default = "C0r3St@ck"
}

variable "LambdaS3Bucket" {
  default = "sqs-templates"
}
 
variable  "LambdaS3key" {
  default = "governance_lambda.zip"
}

variable "SQSRoleName" {
  default = "CS-Test-SQS-Role"
}

variable "regions" {
  type        = set(string)
  default = ["us-east-1"]
}

variable "TopicName" {
  default = "CS-Test-TOPIC-us-east-1"
}

variable "LambdaPolicyName" {
  default = "CS-Test-alert-policy"
}

variable "FolderPath" {
  default = "cfn-files"
}

variable "IAMUser" {
  default = "CS-AssumeRole-User"
}

