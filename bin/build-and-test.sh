#!/bin/bash -e
export RAILS_ENV=test PORT=3333

docker-compose up --build -d
trap "docker-compose down" INT TERM EXIT

docker-compose exec web bundle exec rake db:create
docker-compose exec web bundle exec rake db:migrate

docker-compose exec web bundle exec rake test

