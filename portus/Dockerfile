FROM ruby:2.3

RUN apt-get -qq update \
 && apt-get -qq install mysql-client nodejs -y \
 && rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV production
ENV RACK_ENV deployment
ENV RAILS_GROUPS docker
ENV SKIP_MIGRATION true

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock /app/
RUN bundle config --local frozen 1 \
 && PACKAGING=yes bundle install --retry=3 --system --without=development test --with=docker
COPY . /app/

RUN useradd -r -d /app app \
 && chown -R app:app /app

EXPOSE 3000
USER app

ENTRYPOINT ["/app/entrypoint.sh"]
