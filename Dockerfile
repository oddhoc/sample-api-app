###
# Simple dev env, use build-release.sh to build a releasable image
###
FROM ruby:2.7-alpine3.11

ENV RAILS_ENV=development
EXPOSE 3000
WORKDIR /workspace
RUN apk --no-cache add dumb-init build-base libpq postgresql-dev tzdata

COPY Gemfile* ./
RUN bundler install

ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]
CMD [ "bundle", "exec", "bin/rails", "c" ]