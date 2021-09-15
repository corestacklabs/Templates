output "id" {
  value = "${aws_cloudformation_stack_set.sns.id}"
  #value = tomap({
  #  for k, sns in aws_cloudformation_stack_set.sns : k => sns.outputs
  #})
}

output "outputs" {
  value = "${aws_cloudformation_stack.governance.outputs}"
}

output "lambda" {
  #value = "${aws_cloudformation_stack.lambda.outputs}"
  value = tomap({
    for k, lambda in aws_cloudformation_stack.lambda : k => lambda.outputs
  })
}

output "TopicName" {
  value = var.TopicName
}
