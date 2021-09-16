output "id" {
  value = "${aws_cloudformation_stack_set.sns.id}"
  #value = tomap({
  #  for k, sns in aws_cloudformation_stack_set.sns : k => sns.outputs
  #})
}

output "outputs" {
  value = "${aws_cloudformation_stack.governance.outputs}"
}

output "LambdaArn" {
  #value = "${aws_cloudformation_stack.lambda.outputs}"
  value = tomap({
    for k, lambda in aws_cloudformation_stack.lambda : k => lambda.outputs
  })
}

output "TopicName" {
  value = var.TopicName
}

output "IamUserName" {
  value = var.IAMUser
}

output "IAM_Secret_AccessKey" {
  sensitive   = true
  value       = join("", aws_iam_access_key.key.*.secret)
  description = "The secret access key. This will be written to the state file in plain-text"
}
output = "IAM_AccessKey" {
  value = "${aws_iam_access_key.key.id}"
}
