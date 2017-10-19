FROM ruby:2.4.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /pup-pup-trainer-api
WORKDIR /pup-pup-trainer-api
ADD Gemfile /pup-pup-trainer-api/Gemfile
ADD Gemfile.lock /pup-pup-trainer-api/Gemfile.lock
RUN bundle install
ADD . /pup-pup-trainer-api
