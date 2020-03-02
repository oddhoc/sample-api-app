job "sample-api-app-service" {
    type = "service"
    datacenters = [ "demo" ]

    group "service" {
        count = 1
        restart {
            attempts = 0
            interval = "5m"
            delay = "10s"
            mode = "fail"
        }
        task "app" {
            driver = "docker"
            config {
                image = "quay.io/oddhoc/sample-api-app:[[ env "DEPLOY_TAG" ]]"
                command = "bundle exec foreman start"
                port_map {
                    app = 3000
                    metrics = 9394
                }
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
            resources {
                network {
                    mbits = 10
                    port "app" { }
                    port "metrics" { }
                }
            }
            service {
                name = "sample-api-app-service"
                port = "app"
                tags = [ "urlprefix-/users" ]
                check {
                    name = "app healthcheck"
                    type = "http"
                    path = "/healthcheck"
                    interval = "10s"
                    timeout = "2s"
                }
            }
            service {
                name = "sample-api-app-service-metrics"
                port = "metrics"
                check {
                    name = "metrics healthcheck"
                    type = "http"
                    path = "/metrics"
                    interval = "10s"
                    timeout = "2s"
                }
            }
        }
    }
}