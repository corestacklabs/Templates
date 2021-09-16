provider "aws" {
  region = "us-east-1"
  access_key = var.AccessKeyId
  secret_key = var.SecretAccessKey
}

resource "null_resource" "files" {
  provisioner "local-exec" {
    command = <<EOT
      mkdir "${var.FolderPath}"
      cd "${var.FolderPath}"
      wget "https://corestack-cfn.s3.amazonaws.com/governance_lambda.zip"
      wget "https://corestack-cfn.s3.amazonaws.com/Corestack-Templates/Governance_Lambda_SQS_APIgateway_content.json" 
      wget "https://corestack-cfn.s3.amazonaws.com/Corestack-Templates/AWS_SNS_Create.json"
      wget "https://corestack-cfn.s3.amazonaws.com/Corestack-Templates/AWS_Add_SNS_To_Lambda.json"
    EOT
  }
}


resource "aws_s3_bucket" "b" {
  bucket = var.BucketName
  acl    = "public-read"

  tags = {
    Name        = "cfn"
    Environment = "custom"
  }
}

resource "aws_s3_bucket_object" "upload" {
  for_each = fileset("${var.FolderPath}", "*")

  bucket = var.BucketName
  key    = each.value
  source = "${var.FolderPath}/${each.value}"
  # etag makes the file update when it changes; see https://stackoverflow.com/questions/56107258/terraform-upload-file-to-s3-on-every-apply
  etag   = filemd5("${var.FolderPath}/${each.value}")
  depends_on = [aws_s3_bucket.b]
}


resource "aws_s3_bucket_policy" "b" {
  bucket = aws_s3_bucket.b.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Id": "IAM_User_Access_To_S3",
    "Statement": [
        {
            "Sid": "ExampleStatement01",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "s3:GetObject",
                "s3:GetBucketLocation",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${var.BucketName}/*",
                "arn:aws:s3:::${var.BucketName}"
            ]
        }
    ]
  })
}



resource "aws_cloudformation_stack" "governance" {
  name = "Governnace-stack"
  capabilities = ["CAPABILITY_NAMED_IAM"]
  parameters = {
    LambdaFunctionName = var.LambdaFunctionName
    LambdaRoleName = var.LambdaRoleName
    LambdaPolicyName = var.LambdaPolicyName
    QueueNamePrefix = var.QueueNamePrefix
    #QueueMessageRetentionPeriod = var.QueueMessageRetentionPeriod
    APIGatewayName = var.APIGatewayName
    ExternalID = var.ExternalID
    LambdaS3Bucket = var.BucketName
    LambdaS3key = var.LambdaS3key
    SQSRoleName = var.SQSRoleName
    TrustedAWSAccountID = var.Account_Id
    SQSPolicyName = var.SQSPolicyName
    
  }

  template_url = "https://${var.BucketName}.s3.amazonaws.com/Governance_Lambda_SQS_APIgateway_content.json"
  depends_on = [aws_s3_bucket_object.upload]
}

data "aws_iam_policy_document" "AWSCloudFormationStackSetAdministrationRole_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = ["cloudformation.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "AWSCloudFormationStackSetAdministrationRole" {
  assume_role_policy = data.aws_iam_policy_document.AWSCloudFormationStackSetAdministrationRole_assume_role_policy.json
  name               = "AWSCloudFormationStackSetAdministrationRole"
}

resource "aws_cloudformation_stack_set" "sns" {
  name = "CS-SNS-stackset"
  capabilities = ["CAPABILITY_NAMED_IAM"]
  parameters = {
    TopicName = var.TopicName
    LambdaARN = "${aws_cloudformation_stack.governance.outputs.LambdaARN}"
  }
  template_url = "https://${var.BucketName}.s3.amazonaws.com/AWS_SNS_Create.json"
  depends_on = [aws_cloudformation_stack.governance]
}

data "aws_iam_policy_document" "AWSCloudFormationStackSetAdministrationRole_ExecutionPolicy" {
  statement {
    actions   = ["sts:AssumeRole"]
    effect    = "Allow"
    resources = ["arn:aws:iam::*:role/${aws_cloudformation_stack_set.sns.execution_role_name}"]
  }
}

resource "aws_iam_role_policy" "AWSCloudFormationStackSetAdministrationRole_ExecutionPolicy" {
  name   = "ExecutionPolicy"
  policy = data.aws_iam_policy_document.AWSCloudFormationStackSetAdministrationRole_ExecutionPolicy.json
  role   = aws_iam_role.AWSCloudFormationStackSetAdministrationRole.name
}

resource "aws_cloudformation_stack_set_instance" "sns_stack" {
  for_each = var.regions
  region         = "${each.value}"
  stack_set_name = aws_cloudformation_stack_set.sns.name
  #stack_set_name = tomap({
  #  for k, sns in aws_cloudformation_stack_set.sns : k => sns.name
  #})
   depends_on = [aws_cloudformation_stack_set.sns]
}

data "aws_iam_policy_document" "AWSCloudFormationStackSetExecutionRole_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = [aws_iam_role.AWSCloudFormationStackSetAdministrationRole.arn]
      type        = "AWS"
    }
  }
}

resource "aws_iam_role" "AWSCloudFormationStackSetExecutionRole" {
  assume_role_policy = data.aws_iam_policy_document.AWSCloudFormationStackSetExecutionRole_assume_role_policy.json
  name               = "AWSCloudFormationStackSetExecutionRole"
}

# Documentation: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-prereqs.html
# Additional IAM permissions necessary depend on the resources defined in the StackSet template
data "aws_iam_policy_document" "AWSCloudFormationStackSetExecutionRole_MinimumExecutionPolicy" {
  statement {
    actions = [
      "cloudformation:*",
      "s3:*",
      "sns:*",
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "AWSCloudFormationStackSetExecutionRole_MinimumExecutionPolicy" {
  name   = "MinimumExecutionPolicy"
  policy = data.aws_iam_policy_document.AWSCloudFormationStackSetExecutionRole_MinimumExecutionPolicy.json
  role   = aws_iam_role.AWSCloudFormationStackSetExecutionRole.name
}


resource "aws_cloudformation_stack" "lambda" {
  name = "lambda-stack-${each.value}"
  capabilities = ["CAPABILITY_NAMED_IAM"]
  for_each = var.regions
  parameters = {
    TopicARN = "arn:aws:sns:${each.value}:${var.Account_Id}:${var.TopicName}-${each.value}"
    LambdaARN = "${aws_cloudformation_stack.governance.outputs.LambdaARN}"
  }
  template_url = "https://${var.BucketName}.s3.amazonaws.com/AWS_Add_SNS_To_Lambda.json"
}

resource "aws_iam_user" "assume_role" {
  name = "${var.IAMUser}"

  tags = {
    tag-key = "assumerole"
  }
}

resource "aws_iam_access_key" "key" {
  user = aws_iam_user.assume_role.name
}

resource "aws_iam_user_policy" "policy" {
  name = "assume_role_policy"
  user = aws_iam_user.assume_role.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

