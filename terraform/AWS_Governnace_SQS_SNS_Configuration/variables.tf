variable "TrustedAWSAccountID" {
}
variable "AccessKey" {
}


variable "SecretAccessKey" {
}

variable "LambdaFunctionName" { 
  default = "kalaialert_func"
}

variable "LambdaRoleName" {
  default = "kalai-alert_func_role"
}

variable "SQSPolicyName" {
  default = "kalai-SQS-policy"
}

variable "QueueNamePrefix" {
  default = "kalai-alert"
}

#variable "QueueMessageRetentionPeriod" {
#  default = "259200"
#}

variable "APIGatewayName" {
  default = "kalai-alertAPI"
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

variable "LambdaS3Bucket" {
  default = "sqs-templates"
}
 
variable  "LambdaS3key" {
  default = "governance_lambda.zip"
}

variable "SQSRoleName" {
  default = "kalai-SQS-Role"
}

#variable "regions" {
#  type        = set(string)
#  default = ["us-east-1", "us-east-2"]
#}

variable "TopicName" {
  default = "CS-SNS-NEW-TOPIC"
}

variable "LambdaPolicyName" {
  default = "CS-New-alert-policy"
}


variable "IAMUser" {
  default = "CS-AssumeRole-User"
}

