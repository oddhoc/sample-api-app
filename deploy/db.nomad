job "sample-api-app-db" {
    datacenters = [ "demo" ]
    type = "service"

    group "postgres" {
        count = 1
        restart {
            attempts = 3
            interval = "5m"
            delay = "10s"
            mode = "fail"
        }
        task "postgres" {
            driver = "docker"
            config {
                image = "postgres:12.1-alpine"
                volumes = [
                  "pg-data:/var/lib/postgresql/data"
                ]
                port_map {
                    postgres = 5432
                }
            }
            template {
                destination = "secrets/env"
                env = true
                data = <<EOD
                    {{ with secret "secret/data/services/sample-api-app" }}
                    POSTGRES_PASSWORD="{{ .Data.data.POSTGRES_PASSWORD }}"{{ end }}
                EOD
            }
            resources {
                network {
                    mbits = 10
                    port "postgres" {
                        static = 5432
                    }
                }
            }
            service {
                name = "sample-api-app-db"
                tags = [ "postgres" ]
                port = "postgres"
                check {
                    name = "postgres tcp alive"
                    type = "tcp"
                    interval = "10s"
                    timeout = "2s"
                }
            }
        }
    }
}
