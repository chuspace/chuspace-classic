FROM ruby:2.5

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs libgit2-dev git libvips

RUN mkdir /src

WORKDIR /src

COPY Gemfile /src/Gemfile

COPY Gemfile.lock /src/Gemfile.lock

RUN bundle install --jobs $(expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1) --retry 3 --deployment

COPY . /src

ENV RAILS_ENV=production \
    RACK_ENV=production \
    RAILS_SERVE_STATIC_FILES=true

RUN bin/rails assets:precompile

RUN bin/rails db:migrate

EXPOSE 3000

CMD bundle exec foreman start --formation "$FORMATION"
