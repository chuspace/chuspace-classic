FROM ruby:2.5-alpine AS build-gems

RUN apk --no-cache \
      add -u --repository http://dl-cdn.alpinelinux.org/alpine/edge \
      build-base libc6-compat glib-dev libcurl ca-certificates git postgresql-dev

WORKDIR /src

COPY Gemfile Gemfile.lock ./

RUN bundle config --global frozen 1 \
      && bundle install --without development test -j4 --retry 3 \
      && rm -rf /usr/local/bundle/cache/*.gem \
      && find /usr/local/bundle/gems/ -name "*.c" -delete \
      && find /usr/local/bundle/gems/ -name "*.o" -delete \
      && rm -rf tmp/cache spec

FROM node:alpine AS build-js

WORKDIR /src

RUN apk add -u git

COPY package.json yarn.lock ./

RUN yarn install

COPY . .

RUN NODE_ENV=production yarn run webpack --config config/webpack/production.js \
      && rm -rf node_modules

# Now all the dependencies are installed, create a fresh stage
# with only the runtime libraries we need and none of the build-time
# dependencies. The gems and the compiled javascript can be copied over.

FROM ruby:2.5-alpine

ENV EXECJS_RUNTIME disabled

RUN apk --no-cache \
        add -u --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        postgresql-client libc6-compat glib-dev vips-dev libcurl ca-certificates tzdata

WORKDIR /app

COPY --from=build-gems /usr/local/bundle/ /usr/local/bundle/

COPY --from=build-js /src .

EXPOSE 3000

CMD bundle exec foreman start --formation "$FORMATION"
