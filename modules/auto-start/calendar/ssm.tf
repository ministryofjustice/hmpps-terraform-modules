#-------------------------------------------------------------
### SSM documents
#-------------------------------------------------------------

#Start SSM Document
resource "aws_ssm_document" "start" {
  name              = "${var.environment_name}-start-ec2"
  document_type     = "Automation"
  document_format   = "YAML"
  target_type       = "/AWS::Lambda::Function"
  tags              = "${var.tags}"

  content = <<DOC
  description: '## Starts EC2 instances based on Calendar State'
  schemaVersion: '0.3'
  assumeRole: 'arn:aws:iam::${local.account_id}:role/${local.assume_role}'
  mainSteps:
    - name: checkChangeCalendarOpen
      action: 'aws:assertAwsResourceProperty'
      onFailure: Abort
      timeoutSeconds: 600
      inputs:
        Service: ssm
        Api: GetCalendarState
        CalendarNames:
          - 'arn:aws:ssm:${var.region}:${local.account_id}:document/${local.calendar_name}'
        PropertySelector: $.State
        DesiredValues:
          - CLOSED
      nextStep: startInstances
    - name: startInstances
      action: 'aws:invokeLambdaFunction'
      onFailure: Abort
      timeoutSeconds: 120
      inputs:
        InvocationType: RequestResponse
        FunctionName: "${var.environment_name}-start-ec2"
DOC
}

#Stop SSM Document
resource "aws_ssm_document" "stop" {
  name              = "${var.environment_name}-stop-ec2"
  document_type     = "Automation"
  document_format   = "YAML"
  target_type       = "/AWS::Lambda::Function"
  tags              = "${var.tags}"

  content = <<DOC
  description: '## Stops EC2 instances based on Calendar State'
  schemaVersion: '0.3'
  assumeRole: 'arn:aws:iam::${local.account_id}:role/${local.assume_role}'
  mainSteps:
    - name: checkChangeCalendarOpen
      action: 'aws:assertAwsResourceProperty'
      onFailure: Abort
      timeoutSeconds: 600
      inputs:
        Service: ssm
        Api: GetCalendarState
        CalendarNames:
          - 'arn:aws:ssm:${var.region}:${local.account_id}:document/${local.calendar_name}'
        PropertySelector: $.State
        DesiredValues:
          - OPEN
      nextStep: stopInstances
    - name: stopInstances
      action: 'aws:invokeLambdaFunction'
      onFailure: Abort
      timeoutSeconds: 120
      inputs:
        InvocationType: RequestResponse
        FunctionName: "${var.environment_name}-stop-ec2"
DOC
}

#Change Calendar SSM Document
###Not yet supported in Terraform as new AWS Service
###Document Type- ChangeCalendar and document_format TEXT are not recognised by terraform
#Workaround is to create Calendar by cli

resource "null_resource" "create_calendar" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "sh scripts/create_calendar.sh ${var.calender_content_doc} ${local.calendar_name} ${var.region}"
  }
}
