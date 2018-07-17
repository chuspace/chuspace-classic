FROM ruby:2.5

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev libgit2-dev git libvips libvips-dev nodejs yarn

RUN mkdir /src

WORKDIR /src

COPY Gemfile /src/Gemfile

COPY Gemfile.lock /src/Gemfile.lock

RUN bundle install --jobs $(expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1) --retry 3 --deployment

COPY . /src

RUN bin/rails assets:precompile

RUN bin/rails db:migrate

EXPOSE 3000

CMD bundle exec foreman start --formation "$FORMATION"
