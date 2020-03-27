
#-------------------------------------------------------------
### IAM
#-------------------------------------------------------------
#Policies
resource "aws_iam_policy" "event" {
  name        = "${local.event_role}-policy"
  description = "Policy to allow Event rule to invoke SSM Document"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "ssm:StartAutomationExecution",
      "Effect": "Allow",
      "Resource": [
          "arn:aws:ssm:${var.region}:${local.account_id}:automation-definition/${var.environment_name}-start-ec2:$DEFAULT",
          "arn:aws:ssm:${var.region}:${local.account_id}:automation-definition/${var.environment_name}-stop-ec2:$DEFAULT"
      ]
    }
   ]
}
EOF
}

resource "aws_iam_policy" "assume" {
  name        = "${local.assume_role}-policy"
  description = "Policy to allow SSM Automation to invoke Lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "cloudwatch:PutMetricData",
          "ds:CreateComputer",
          "ds:DescribeDirectories",
          "ec2:DescribeInstanceStatus",
          "logs:*",
          "ssm:*",
          "ec2messages:*"
      ],
      "Resource": "*"
  },
  {
      "Effect": "Allow",
      "Action": "iam:CreateServiceLinkedRole",
      "Resource": "arn:aws:iam::*:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM*",
      "Condition": {
          "StringLike": {
              "iam:AWSServiceName": "ssm.amazonaws.com"
          }
      }
  },
  {
      "Effect": "Allow",
      "Action": [
          "iam:DeleteServiceLinkedRole",
          "iam:GetServiceLinkedRoleDeletionStatus"
      ],
      "Resource": "arn:aws:iam::*:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM*"
  },
  {
      "Effect": "Allow",
      "Action": [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
      ],
      "Resource": "*"
  },
  {
      "Effect": "Allow",
      "Action": [
          "ec2:CreateImage",
          "ec2:CopyImage",
          "ec2:DeregisterImage",
          "ec2:DescribeImages",
          "ec2:DeleteSnapshot",
          "ec2:StartInstances",
          "ec2:RunInstances",
          "ec2:StopInstances",
          "ec2:TerminateInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:CreateTags",
          "ec2:DeleteTags",
          "ec2:DescribeTags",
          "cloudformation:CreateStack",
          "cloudformation:DescribeStackEvents",
          "cloudformation:DescribeStacks",
          "cloudformation:UpdateStack",
          "cloudformation:DeleteStack"
      ],
      "Resource": [
          "*"
      ]
  },
  {
      "Effect": "Allow",
      "Action": [
          "ssm:*"
      ],
      "Resource": [
          "*"
      ]
  },
  {
      "Effect": "Allow",
      "Action": [
          "sns:Publish"
      ],
      "Resource": [
          "arn:aws:sns:*:*:Automation*"
      ]
  },
  {
      "Effect": "Allow",
      "Action": [
          "lambda:InvokeFunction"
      ],
      "Resource": [
          "*"
      ]
  },
  {
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": "arn:aws:iam::${local.account_id}:role/${local.assume_role}"
  }
]
}
EOF
}


#IAM Roles

resource "aws_iam_role" "assume" {
  name = "${local.assume_role}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ssm.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}


resource "aws_iam_role" "event" {
  name = "${local.event_role}"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "events.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

#IAM Policy attachment

resource "aws_iam_role_policy_attachment" "assume" {
  role       = "${aws_iam_role.assume.name}"
  policy_arn = "${aws_iam_policy.assume.arn}"
}

resource "aws_iam_role_policy_attachment" "event" {
  role       = "${aws_iam_role.event.name}"
  policy_arn = "${aws_iam_policy.event.arn}"
}
