FROM node:10.7.0-alpine AS nodebuild
WORKDIR /src

RUN apk add --no-cache libgit2-dev git
COPY package.json yarn.lock /src/
RUN yarn install

FROM ruby:2.5.1-alpine
WORKDIR /src
COPY --from=nodebuild . /

RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing \
  vips-tools vips-dev postgresql-dev zip unzip libgit2-dev git \
  && apk add --virtual build-base

COPY Gemfile Gemfile.lock /src/

RUN bundle install --jobs $(expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1) --retry 3 --deployment

COPY . /src

RUN NODE_ENV=production bin/webpack

EXPOSE 3000
CMD bundle exec foreman start --formation "$FORMATION"
