FROM ruby:3.2.2-slim

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  npm \
  git \
  && rm -rf /var/lib/apt/lists/*

RUN gem install bundler

WORKDIR /rails

COPY Gemfile Gemfile.lock ./

# ✅ ИСПРАВЛЕНО: используем bundle config
RUN bundle config set without 'development test' && bundle install

COPY . .

RUN SECRET_KEY_BASE=dummy RAILS_ENV=production ./bin/rails assets:precompile

EXPOSE 3000


CMD ["./bin/rails", "server"]
