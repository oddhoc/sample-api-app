job "sample-api-app-batch" {
    type = "batch"
    datacenters = [ "demo" ]
    parameterized {
        payload       = "optional"
        meta_required = ["command"]
    }
    group "runner" {
        restart {
            attempts = 0
            mode = "fail"
        }
        task "run" {
            driver = "docker"
            config {
                image = "quay.io/oddhoc/sample-api-app:[[ env "DEPLOY_TAG" ]]"
                command = "${NOMAD_META_command}"
            }
            template {
                destination = "secrets/env"
                env = true
                data = <<EOD
                    {{ with secret "secret/data/services/sample-api-app" }}
                    PORT=3000
                    RAILS_ENV="{{ key "services/sample-api-app/RAILS_ENV" }}"
                    RAILS_MASTER_KEY="{{ .Data.data.RAILS_MASTER_KEY }}"
                    DATABASE_URL="postgres://postgres:{{ .Data.data.POSTGRES_PASSWORD }}@sample-api-app-db.service.consul/sample_api_app_{{ key "services/sample-api-app/RAILS_ENV" }}"
                    {{ end }}
                EOD
            }
        }
    }
}