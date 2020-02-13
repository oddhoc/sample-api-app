#!/bin/bash -e

pack build sample-api-app --builder heroku/buildpacks:18

# need to test stuff in the container you just built?
# do it like so:
# docker run --rm -e RAILS_ENV=production -it sample-api-app:latest "bundle exec rake -T"
# or exec into a running container like so
# docker exec -it ID /cnb/lifecycle/launcher "bundle exec rake -T"