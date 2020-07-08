#-------------------------------------------------------------
### SSM documents
#-------------------------------------------------------------

#Start SSM Document
resource "aws_ssm_document" "start" {
  name            = "${var.environment_name}-start-ec2"
  document_type   = "Automation"
  document_format = "YAML"
  target_type     = "/AWS::Lambda::Function"
  tags            = var.tags

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
      nextStep: startInstancesPhase1
    - name: startInstancesPhase1
      action: 'aws:invokeLambdaFunction'
      onFailure: Abort
      timeoutSeconds: 120
      inputs:
        InvocationType: RequestResponse
        FunctionName: "${var.environment_name}-start-ec2-phase1"
      nextStep: sleep
    - name: "sleep"
      action: "aws:sleep"
      inputs:
        Duration: "PT10M"
      nextStep: startInstancesPhase2
    - name: startInstancesPhase2
      action: 'aws:invokeLambdaFunction'
      onFailure: Abort
      timeoutSeconds: 120
      inputs:
        InvocationType: RequestResponse
        FunctionName: "${var.environment_name}-start-ec2-phase2"
DOC

}

#Stop SSM Document
resource "aws_ssm_document" "stop" {
  name            = "${var.environment_name}-stop-ec2"
  document_type   = "Automation"
  document_format = "YAML"
  target_type     = "/AWS::Lambda::Function"
  tags            = var.tags

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
      nextStep: stopInstancesPhase2
    - name: stopInstancesPhase2
      action: 'aws:invokeLambdaFunction'
      onFailure: Abort
      timeoutSeconds: 120
      inputs:
        InvocationType: RequestResponse
        FunctionName: "${var.environment_name}-stop-ec2-phase2"
      nextStep: stopInstancesPhase1
    - name: stopInstancesPhase1
      action: 'aws:invokeLambdaFunction'
      onFailure: Abort
      timeoutSeconds: 120
      inputs:
        InvocationType: RequestResponse
        FunctionName: "${var.environment_name}-stop-ec2-phase1"
DOC

}

#Change Calendar SSM Document
###Not yet supported in Terraform as new AWS Service
###Document Type- ChangeCalendar and document_format TEXT are not recognised by terraform
#Workaround is to create Calendar by cli

resource "null_resource" "create_calendar" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "sh scripts/create_calendar.sh ${var.calender_content_doc} ${local.calendar_name} ${var.region}"
  }
}

