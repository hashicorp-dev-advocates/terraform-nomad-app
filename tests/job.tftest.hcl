variables {
  waypoint_application = "fake-service"
  application_port     = 9090
  application_count    = 1
  image                = "nicholasjackson/fake-service:v0.26.2"
  driver               = "docker"
  service_provider     = "nomad"
  node_pool            = "default"
  applications = {
    "fake-service" = {
      waypoint_clues = "TODO: waypoint clue"
      nomad_clues    = "TODO: nomad clue"
      node_pool      = "containers"
      port           = 9090
    },
  }
}

run "run_job" {
  assert {
    condition     = length(nomad_variable.application) == 1
    error_message = "Should have 1 nomad variables set"
  }

  assert {
    condition     = jsondecode(nomad_job.application.jobspec).Name == "fake-service"
    error_message = "Job spec name did not match `fake-service`"
  }

  assert {
    condition     = jsondecode(nomad_job.application.jobspec).Meta["waypoint.additional_details"] == "TODO: waypoint clue"
    error_message = "Job spec metadata did not contain `TODO: waypoint clue`"
  }
}

run "check_job" {
  module {
    source = "./tests/setup"
  }

  assert {
    condition     = data.nomad_job.test.status == "running"
    error_message = "Nomad job should have status `running`"
  }
}
