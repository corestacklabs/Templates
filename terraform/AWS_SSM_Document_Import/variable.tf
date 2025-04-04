variable "aws_region" {
  description = "AWS region to deploy the SSM document"
  type        = string
  default     = "us-east-1"
  
}

variable "github_repo_url" {
  description = "GitHub repository URL containing the SSM command template"
  type        = string
}

variable "ssm_document_name" {
  description = "Name of the SSM document"
  type        = string
  default     = "ssm-document-for-automation"
}
variable "ssm_document_format" {
  description = "Format of the SSM document"
  type        = string
  default     = "YAML"
}
variable "ssm_document_type" {
  description = "Type of the SSM document"
  type        = string
  default     = "Command"
}
variable "ssm_document_tags" {
  description = "Tags for the SSM document"
  type        = map(string)
  default     = {
    Name = "ssm-document-for-automation"
  }
}

variable "file_path"{
  description = "File name of the SSM document template"
  type        = string
}