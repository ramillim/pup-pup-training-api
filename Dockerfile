FROM ruby:2.4.2

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

ENV APP_HOME /pup-pup-training-api

RUN mkdir $APP_HOME

WORKDIR $APP_HOME

ADD Gemfile $APP_HOME/Gemfile
ADD Gemfile.lock $APP_HOME/Gemfile.lock

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
  BUNDLE_PATH=/bundle \
  BUNDLE_BIN=/bundle/bin \
  BUNDLE_JOBS=2
ENV PATH="${BUNDLE_BIN}:${PATH}"
ENV GEM_HOME=$BUNDLE_PATH

RUN bundle install

ADD . $APP_HOME
