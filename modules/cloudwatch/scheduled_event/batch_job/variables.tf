variable "event_name" {
  description = "Event name string"
  type        = "string"
}

variable "event_desc" {
  description = "Description of the purpose of this event"
  type        = "string"
}

variable "event_schedule" {
  description = "Either a cron or rate schedule string"
  type        = "string"
}

variable "event_job_queue_arn" {
  description = "ARN for Job Queue to submit job to"
  type        = "string"
}

variable "event_job_def_id" {
  description = "Job Defintiion ID to submit job to"
  type        = "string"
}

variable "event_job_attempts" {
  description = "Retry count for failed jobs"
  type        = "number"
}
