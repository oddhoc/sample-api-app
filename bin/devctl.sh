#! /bin/bash
export RAILS_ENV=development
export PORT=3000

case "$1" in
    "up")
        docker-compose up --build -d
        docker-compose exec web rake db:create db:migrate
    ;;
    "sh")
        docker-compose exec web sh
    ;;
    *)
         docker-compose "$@"
    ;;
esac