output "job_id" {
  value = nomad_job.application.id
}

output "clue" {
  value     = var.applications[var.waypoint_application].waypoint_clues
  sensitive = true
}