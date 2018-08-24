FROM ruby:2.5

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y \
      build-essential \
      libpq-dev \
      postgresql-client \
      git  \
      libvips \
      libvips-dev \
      nodejs \
      yarn\
      cmake \
      libssl-dev

RUN mkdir /src

WORKDIR /src

COPY Gemfile Gemfile.lock /src/

RUN bundle install --jobs $(expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1) --retry 3 --deployment --without development,test \
      && rm -rf /usr/local/bundle/cache/*.gem \
      && find /usr/local/bundle/gems/ -name "*.c" -delete \
      && find /usr/local/bundle/gems/ -name "*.o" -delete \
      && rm -rf tmp/cache spec

COPY package.json yarn.lock /src/

RUN yarn install

COPY . /src

RUN NODE_ENV=production bin/webpack && rm -rf node_modules

EXPOSE 3000

CMD bundle exec foreman start --formation "$FORMATION"
