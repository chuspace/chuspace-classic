FROM ruby:2.5 AS build

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev libvips libvips-dev nodejs yarn

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

FROM ruby:2.5-alpine

ENV EXECJS_RUNTIME disabled

RUN apk --no-cache \
        add -u --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        postgresql-client libc6-compat glib-dev vips-dev

WORKDIR /app

COPY --from=build /usr/local/bundle/ /usr/local/bundle/

COPY --from=build /src .

EXPOSE 3000

CMD bundle exec foreman start --formation "$FORMATION"
