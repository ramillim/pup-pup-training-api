# Pup Pup Training API

[![CircleCI](https://circleci.com/gh/ramillim/pup-pup-training-api.svg?style=svg)](https://circleci.com/gh/ramillim/pup-pup-training-api)

[![Maintainability](https://api.codeclimate.com/v1/badges/571f942c35e5fbddbd00/maintainability)](https://codeclimate.com/github/ramillim/pup-pup-training-api/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/571f942c35e5fbddbd00/test_coverage)](https://codeclimate.com/github/ramillim/pup-pup-training-api/test_coverage)

## Development

This project uses Docker Engine and Docker Compose for development and testing. Download and install Docker here:

https://docs.docker.com/engine/installation/
https://docs.docker.com/compose/install/

To prepare the development environment, execute the following. This will build and start the Rails server and Postgres database in the background. After that, it creates the dev and test databases and runs migrations.
```bash
docker-compose build

docker-compose up -d

docker-compose exec web bundle exec rails db:create db:migrate db:test:prepare
```

To stop the containers if running in the background with the -d option, use:
```bash
docker-compose stop
```

Commands are executed on the "web" container using "docker-compose run web" followed by the commands to execute on the container.

To run tests with rspec:
```bash
docker-compose run web bundle exec rspec
```

## Production

Production secrets are stored as environment variables and not included in the repo. The following is a list of required variables:

**PUP-PUP-TRAINER-API_DATABASE_PASSWORD** : Postgres database password

## Continuous Integration

[CircleCI](https://circleci.com/gh/ramillim/pup-pup-training-api) is used to automatically build all branches pushed to GitHub. The .circleci/config.yml file contains steps to submit the code coverage report generated by SimpleCov gem to [CodeClimate](https://codeclimate.com/github/ramillim/pup-pup-training-api/) for tracking.

You can also run CircleCI locally with the [CircleCI CLI](https://circleci.com/docs/2.0/local-jobs/) to validate changes to the configuration. Download and install the CLI tool using the link provided. 
