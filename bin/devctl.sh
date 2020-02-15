#! /bin/bash
export RAILS_ENV=development

if [ "$1" == "up" ] ; then
    docker-compose up --build -d
    docker-compose exec web rake db:create db:migrate
elif [ "$1" == "sh" ] ; then
    docker-compose exec web sh
else
    docker-compose "$@"
fi
