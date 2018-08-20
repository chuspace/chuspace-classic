FROM ruby:2.5-alpine AS build

RUN apk add -u build-base libc6-compat glib-dev libcurl ca-certificates git postgresql-dev yarn

RUN mkdir /src

WORKDIR /src

COPY Gemfile Gemfile.lock ./

RUN bundle config --global frozen 1 \
      && bundle install --without development test -j4 --retry 3 \
      && rm -rf /usr/local/bundle/cache/*.gem \
      && find /usr/local/bundle/gems/ -name "*.c" -delete \
      && find /usr/local/bundle/gems/ -name "*.o" -delete


COPY package.json yarn.lock ./

RUN yarn install

COPY . .

RUN NODE_ENV=production bin/webpack

RUN rm -rf tmp/cache spec node_modules

# Now all the dependencies are installed, create a fresh stage
# with only the runtime libraries we need and none of the build-time
# dependencies. The gems and the compiled javascript can be copied over.

FROM ruby:2.5-alpine

ENV EXECJS_RUNTIME disabled

RUN apk --no-cache \
        add -u --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        postgresql-client libc6-compat glib-dev vips-dev libcurl ca-certificates

WORKDIR /app

COPY --from=build /usr/local/bundle/ /usr/local/bundle/

COPY --from=build /src .

EXPOSE 3000

CMD bundle exec foreman start --formation "$FORMATION"
