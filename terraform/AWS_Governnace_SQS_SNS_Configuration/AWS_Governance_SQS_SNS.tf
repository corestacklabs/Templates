provider "aws" {
  region = "us-east-1"
  access_key = var.AccessKey
  secret_key = var.SecretAccessKey
}

resource "aws_sqs_queue" "alert_queue" {
  name                      = "${var.QueueNamePrefix}-alert"
  message_retention_seconds = 1209600
  tags = {
    Environment = "production"
  }
}
resource "aws_sqs_queue" "activity_log_queue" {
  name                      = "${var.QueueNamePrefix}-activity-log"
  message_retention_seconds = 1209600
  tags = {
    Environment = "production"
  }
}
resource "aws_sqs_queue" "script_queue" {
  name                      = "${var.QueueNamePrefix}-script"
  message_retention_seconds = 1209600
  tags = {
    Environment = "production"
  }
}
resource "aws_sqs_queue" "shallow_queue" {
  name                      = "${var.QueueNamePrefix}-shallowdiscovery"
  message_retention_seconds = 1209600
  tags = {
    Environment = "production"
  }
}
resource "aws_sqs_queue" "deep_discovery_queue" {
  name                      = "${var.QueueNamePrefix}-deepdiscovery"
  message_retention_seconds = 1209600
  tags = {
    Environment = "production"
  }
}
resource "aws_sqs_queue" "automated_discovery_queue" {
  name                      = "${var.QueueNamePrefix}-automateddiscovery"
  message_retention_seconds = 1209600
  tags = {
    Environment = "production"
  }
}


resource "aws_lambda_function" "governance_lambda" {
  depends_on = [aws_iam_role_policy.lambda_access_policy, aws_iam_role.lambda_access_role]
  function_name = var.LambdaFunctionName
  role = aws_iam_role.lambda_access_role.arn
  handler = "index.lambda_handler"
  s3_bucket = var.LambdaS3Bucket
  s3_key = var.LambdaS3key
  timeout = 300
  runtime = "python3.9"
  environment {
    variables = {
      Queue_Name = "${var.QueueNamePrefix}-alert"
      Encryption_String = "C0r3St@ck"
    }
  }
}

resource "aws_iam_role_policy" "sqs_access_policy" {
  depends_on = [aws_sqs_queue.alert_queue, aws_sqs_queue.activity_log_queue, aws_sqs_queue.script_queue, aws_sqs_queue.shallow_queue, aws_sqs_queue.deep_discovery_queue, aws_iam_role.sqs_access_role ]
  name = var.SQSPolicyName
  role = aws_iam_role.sqs_access_role.id
  policy = jsonencode(
  {
    Version = "2012-10-17"
    Statement = [{
       Effect = "Allow"
       Action = [
          "sqs:DeleteMessage",
          "sqs:ReceiveMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sqs:SendMessage"
        ]
        Resource = [
          "${aws_sqs_queue.alert_queue.arn}",
          "${aws_sqs_queue.activity_log_queue.arn}",
          "${aws_sqs_queue.script_queue.arn}",
          "${aws_sqs_queue.shallow_queue.arn}",
          "${aws_sqs_queue.deep_discovery_queue.arn}"
        ]
    }]

  })
}


resource "aws_iam_role" "sqs_access_role" {
  name = var.SQSRoleName

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = var.TrustedAWSAccountID
      }
      Condition = {
        StringEquals = {
           "sts:ExternalId" = "${var.ExternalId}"
        }
      }
      Action = "sts:AssumeRole"
    }]

  })
}

resource "aws_iam_role_policy" "lambda_access_policy" {
  depends_on = [aws_iam_role.lambda_access_role]
  name = var.LambdaPolicyName
  role = aws_iam_role.lambda_access_role.id
  policy = jsonencode({

    Version = "2012-10-17"
    Statement = [{
       Effect = "Allow"
       Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
       ]
       Resource = [
          "arn:aws:logs:*:*:*"
       ]
    },
    {
      Effect = "Allow"
      Action = [ "sts:AssumeRole" ]
      Resource = ["*"]
    }]

  })
}

resource "aws_iam_role" "lambda_access_role" {
  name = var.LambdaRoleName

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = [
           "lambda.amazonaws.com"
        ]
      }
      Action = [
        "sts:AssumeRole"
      ]
    }]
  })
  managed_policy_arns= [
     "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
  ]
}

resource "aws_api_gateway_rest_api" "notify_api" {
  name = var.APIGatewayName
  description = "API used for notify requests"
#  failonwarnings = true
}

data "aws_region" "current" {}

resource "aws_lambda_permission" "lambda_permission" {
  action = "lambda:invokeFunction"
  function_name = aws_lambda_function.governance_lambda.arn
  principal = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${var.TrustedAWSAccountID}:${aws_api_gateway_rest_api.notify_api.id}/*"
}

resource "aws_iam_role_policy" "api_gateway_log_policy" {
  depends_on = [aws_iam_role.api_cloudwatch_role]
  name = "ApiGatewayLogsPolicy"
  role = aws_iam_role.api_cloudwatch_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
       Effect = "Allow"
       Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
       ],
       Resource = [
          "*"
       ]
    }]
  })
}

resource "aws_iam_role" "api_cloudwatch_role" {
  name = "ApiCloudWatchRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = [
           "apigateway.amazonaws.com"
        ]
      }
      Action = [
        "sts:AssumeRole"
      ]
    }]
  })
}

resource "aws_api_gateway_account" "api_cloudwatch_log_role" {
  depends_on = [aws_iam_role.api_cloudwatch_role]
  cloudwatch_role_arn = aws_iam_role.api_cloudwatch_role.arn
}

resource "aws_api_gateway_deployment" "notify_api_deployment" {
  depends_on = [aws_api_gateway_rest_api.notify_api, aws_api_gateway_method.notify_api_method, aws_api_gateway_integration.notify_integration]
  rest_api_id = aws_api_gateway_rest_api.notify_api.id
  
}
resource "aws_api_gateway_stage" "notify_api_stage" {
  depends_on = [aws_api_gateway_rest_api.notify_api, aws_api_gateway_deployment.notify_api_deployment]
  deployment_id = aws_api_gateway_deployment.notify_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.notify_api.id
  stage_name    = "Core-stage"
}

resource "aws_api_gateway_method_settings" "method_settings" {
  depends_on = [aws_api_gateway_rest_api.notify_api, aws_api_gateway_stage.notify_api_stage]
  rest_api_id = aws_api_gateway_rest_api.notify_api.id
  stage_name  = aws_api_gateway_stage.notify_api_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
    data_trace_enabled = true
  }
}

resource "aws_api_gateway_resource" "notify_api_resource" {
  depends_on = [aws_api_gateway_rest_api.notify_api]
  rest_api_id = aws_api_gateway_rest_api.notify_api.id
  parent_id   = aws_api_gateway_rest_api.notify_api.root_resource_id
  path_part   = "alerts"
}

resource "aws_api_gateway_method" "notify_api_method" {
  depends_on = [aws_api_gateway_rest_api.notify_api, aws_api_gateway_resource.notify_api_resource]
  rest_api_id   = aws_api_gateway_rest_api.notify_api.id
  resource_id   = aws_api_gateway_resource.notify_api_resource.id
  http_method   = "POST"
  authorization = "NONE"
  request_parameters = {
    "method.request.querystring.service_account_id" = false
    "method.request.querystring.alert_type" = false
  }

}

resource "aws_api_gateway_method_response" "response_200" {
  depends_on = [aws_api_gateway_rest_api.notify_api, aws_api_gateway_resource.notify_api_resource, aws_api_gateway_method.notify_api_method]
  rest_api_id   = aws_api_gateway_rest_api.notify_api.id
  resource_id   = aws_api_gateway_resource.notify_api_resource.id
  http_method   = "POST"
  status_code = "200"
}

resource "aws_api_gateway_integration" "notify_integration" {
  depends_on = [aws_api_gateway_rest_api.notify_api, aws_api_gateway_resource.notify_api_resource, aws_api_gateway_method.notify_api_method]
  rest_api_id          = aws_api_gateway_rest_api.notify_api.id
  resource_id          = aws_api_gateway_resource.notify_api_resource.id
  http_method          = aws_api_gateway_method.notify_api_method.http_method
  type                 = "AWS"
  integration_http_method = "POST"

  uri = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${aws_lambda_function.governance_lambda.arn}/invocations"
  request_parameters = {
    "integration.request.querystring.service_account_id" = "'method.request.querystring.service_account_id'",
    "integration.request.querystring.alert_type" = "'method.request.querystring.alert_type'"
#    "method.request.querystring.service_account_id" = false,
#    "method.request.querystring.alert_type" = false

  }

  # Transforms the incoming XML request to JSON
  request_templates = {
    "application/json" = <<EOF
           {   "Fn::Join": [
               "",
                [
                  "#set($allParams = $input.params())\n",
                  "{\n",
                  "  \"body-json\": $input.json('$'),\n",
                  "  \"params\" : {\n",
                  "    #foreach($type in $allParams.keySet())\n",
                  "      #set($params = $allParams.get($type))\n",
                  "      \"$type\" : {\n",
                  "        #foreach($paramName in $params.keySet())\n",
                  "          \"$paramName\" : \"$util.escapeJavaScript($params.get($paramName))\"\n",
                  "          #if($foreach.hasNext),#end\n",
                  "        #end\n",
                  "      }\n",
                  "    #if($foreach.hasNext),#end\n",
                  "    #end\n",
                  "  },\n",
                  "  \"stage-variables\": {\n",
                  "    #foreach($key in $stageVariables.keySet())\n",
                  "      \"$key\" : \"$util.escapeJavaScript($stageVariables.get($key))\"\n",
                  "      #if($foreach.hasNext),#end\n",
                  "    #end\n",
                  "  },\n",
                  "  \"context\" : {\n",
                  "    \"account-id\" : \"$context.identity.accountId\",\n",
                  "    \"api-id\" : \"$context.apiId\",\n",
                  "    \"api-key\" : \"$context.identity.apiKey\",\n",
                  "    \"authorizer-principal-id\" : \"$context.authorizer.principalId\",\n",
                  "    \"caller\" : \"$context.identity.caller\",\n",
                  "    \"cognito-authentication-provider\" : \"$context.identity.cognitoAuthenticationProvider\",\n",
                  "    \"cognito-authentication-type\" : \"$context.identity.cognitoAuthenticationType\",\n",
                  "    \"cognito-identity-id\" : \"$context.identity.cognitoIdentityId\",\n",
                  "    \"cognito-identity-pool-id\" : \"$context.identity.cognitoIdentityPoolId\",\n",
                  "    \"http-method\" : \"$context.httpMethod\",\n",
                  "    \"stage\" : \"$context.stage\",\n",
                  "    \"source-ip\" : \"$context.identity.sourceIp\",\n",
                  "    \"user\" : \"$context.identity.user\",\n",
                  "    \"user-agent\" : \"$context.identity.userAgent\",\n",
                  "    \"user-arn\" : \"$context.identity.userArn\",\n",
                  "    \"request-id\" : \"$context.requestId\",\n",
                  "    \"resource-id\" : \"$context.resourceId\",\n",
                  "    \"resource-path\" : \"$context.resourcePath\"\n",
                  "  }\n",
                  "}"
                ]
              ] }
       EOF
       }
#  request_parameters = {
#    "method.request.querystring.service_account_id" = "false",
#    "method.request.querystring.alert_type" = "false"
#  }
}



resource "aws_api_gateway_integration_response" "notify_response" {
  depends_on = [aws_api_gateway_rest_api.notify_api, aws_api_gateway_resource.notify_api_resource, aws_api_gateway_method.notify_api_method, aws_api_gateway_method_response.response_200, aws_api_gateway_integration.notify_integration]
  rest_api_id = aws_api_gateway_rest_api.notify_api.id
  resource_id = aws_api_gateway_resource.notify_api_resource.id
  http_method = aws_api_gateway_method.notify_api_method.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
}

resource "aws_api_gateway_resource" "schedule_api_resource" {
  depends_on = [aws_api_gateway_rest_api.notify_api]
  rest_api_id = aws_api_gateway_rest_api.notify_api.id
  parent_id   = aws_api_gateway_rest_api.notify_api.root_resource_id
  path_part   = "resolve"
}

resource "aws_api_gateway_request_validator" "schedule_api_validator" {
  depends_on = [aws_api_gateway_rest_api.notify_api]
  name                        = "schedule_req_validator"
  rest_api_id                 = aws_api_gateway_rest_api.notify_api.id
  validate_request_body       = true
  validate_request_parameters = true
}

resource "aws_api_gateway_method" "schedule_api_method" {
  depends_on = [aws_api_gateway_rest_api.notify_api, aws_api_gateway_resource.schedule_api_resource, aws_api_gateway_request_validator.schedule_api_validator]
  rest_api_id   = aws_api_gateway_rest_api.notify_api.id
  resource_id   = aws_api_gateway_resource.schedule_api_resource.id
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.querystring.service_account_id" = true
    "method.request.querystring.project_id" = true
    "method.request.querystring.schedule_id" = true
   }

  request_validator_id = aws_api_gateway_request_validator.schedule_api_validator.id
}

resource "aws_api_gateway_method_response" "schedule_api_response_200" {
  depends_on = [aws_api_gateway_method.schedule_api_method,aws_api_gateway_rest_api.notify_api,aws_api_gateway_resource.schedule_api_resource]
  rest_api_id   = aws_api_gateway_rest_api.notify_api.id
  resource_id   = aws_api_gateway_resource.schedule_api_resource.id
  http_method   = "GET"
  status_code = "200"
}

resource "aws_api_gateway_integration" "schedule_integration" {
  depends_on = [aws_api_gateway_rest_api.notify_api, aws_api_gateway_resource.schedule_api_resource, aws_api_gateway_method.schedule_api_method, aws_lambda_function.governance_lambda]
  rest_api_id          = aws_api_gateway_rest_api.notify_api.id
  resource_id          = aws_api_gateway_resource.schedule_api_resource.id
  http_method          = aws_api_gateway_method.schedule_api_method.http_method
  type                 = "AWS"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.governance_lambda.invoke_arn
  #uri = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${aws_lambda_function.governance_lambda.arn}/invocations"
  request_parameters = {
    "integration.request.querystring.service_account_id": "method.request.querystring.service_account_id",
    "integration.request.querystring.schedule_id": "method.request.querystring.schedule_id",
    "integration.request.querystring.project_id": "method.request.querystring.project_id"
 #   "method.request.querystring.service_account_id": true,
 #   "method.request.querystring.project_id": true,
 #   "method.request.querystring.schedule_id": true
  }

  # Transforms the incoming XML request to JSON
  request_templates = {
    "application/json" = <<EOF
                {
              "Fn::Join": [
                "",
                [
                  "#set($allParams = $input.params())\n",
                  "{\n",
                  "  \"body-json\": $input.json('$'),\n",
                  "  \"params\" : {\n",
                  "    #foreach($type in $allParams.keySet())\n",
                  "      #set($params = $allParams.get($type))\n",
                  "      \"$type\" : {\n",
                  "        #foreach($paramName in $params.keySet())\n",
                  "          \"$paramName\" : \"$util.escapeJavaScript($params.get($paramName))\"\n",
                  "          #if($foreach.hasNext),#end\n",
                  "        #end\n",
                  "      }\n",
                  "    #if($foreach.hasNext),#end\n",
                  "    #end\n",
                  "  },\n",
                  "  \"stage-variables\": {\n",
                  "    #foreach($key in $stageVariables.keySet())\n",
                  "      \"$key\" : \"$util.escapeJavaScript($stageVariables.get($key))\"\n",
                  "      #if($foreach.hasNext),#end\n",
                  "    #end\n",
                  "  },\n",
                  "  \"context\" : {\n",
                  "    \"account-id\" : \"$context.identity.accountId\",\n",
                  "    \"api-id\" : \"$context.apiId\",\n",
                  "    \"api-key\" : \"$context.identity.apiKey\",\n",
                  "    \"authorizer-principal-id\" : \"$context.authorizer.principalId\",\n",
                  "    \"caller\" : \"$context.identity.caller\",\n",
                  "    \"cognito-authentication-provider\" : \"$context.identity.cognitoAuthenticationProvider\",\n",
                  "    \"cognito-authentication-type\" : \"$context.identity.cognitoAuthenticationType\",\n",
                  "    \"cognito-identity-id\" : \"$context.identity.cognitoIdentityId\",\n",
                  "    \"cognito-identity-pool-id\" : \"$context.identity.cognitoIdentityPoolId\",\n",
                  "    \"http-method\" : \"$context.httpMethod\",\n",
                  "    \"stage\" : \"$context.stage\",\n",
                  "    \"source-ip\" : \"$context.identity.sourceIp\",\n",
                  "    \"user\" : \"$context.identity.user\",\n",
                  "    \"user-agent\" : \"$context.identity.userAgent\",\n",
                  "    \"user-arn\" : \"$context.identity.userArn\",\n",
                  "    \"request-id\" : \"$context.requestId\",\n",
                  "    \"resource-id\" : \"$context.resourceId\",\n",
                  "    \"resource-path\" : \"$context.resourcePath\"\n",
                  "  }\n",
                  "}"
                ]
              ]
            }
        EOF
       }

}


resource "aws_api_gateway_integration_response" "schedule_response" {
  depends_on = [aws_api_gateway_rest_api.notify_api, aws_api_gateway_resource.schedule_api_resource, aws_api_gateway_method.schedule_api_method, aws_api_gateway_method_response.schedule_api_response_200, aws_api_gateway_integration.schedule_integration]
  rest_api_id = aws_api_gateway_rest_api.notify_api.id
  resource_id = aws_api_gateway_resource.schedule_api_resource.id
  http_method = aws_api_gateway_method.schedule_api_method.http_method
  status_code = aws_api_gateway_method_response.schedule_api_response_200.status_code
}

resource "aws_sns_topic" "topic" {
#SNS topic on Multiple region not supported 
  #for_each = var.regions
  #region   = "${each.value}"

  name = var.TopicName
}

resource "aws_sns_topic_policy" "custom" {
  arn = "${aws_sns_topic.topic.arn}"
  policy = <<POLICY
{

          "Version": "2012-10-17",
          "Statement": [
            {
              "Effect": "Allow",
              "Principal": {
                "AWS": "*"
              },
              "Action": "SNS:Publish",
              "Resource": "${aws_sns_topic.topic.arn}"
            },
            {
              "Sid": "AllowEventsFromS3",
              "Effect": "Allow",
              "Principal": {
                "Service": "s3.amazonaws.com"
              },
              "Action": "SNS:Publish",
              "Resource": "${aws_sns_topic.topic.arn}"
            }
          ]
}
POLICY
}

resource "aws_sns_topic_subscription" "lambda_subscription" {
 # for_each = var.regions
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.governance_lambda.arn
}

resource "aws_lambda_permission" "with_sns" {
#  for_each = var.regions
#  source_arn = "arn:aws:sns:${each.value}:${var.Account_Id}:${var.TopicName}-${each.value}"

  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.governance_lambda.arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.topic.arn
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

