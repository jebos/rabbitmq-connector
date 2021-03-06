#!/usr/bin/env bash

echo "Logging into DockerHub"
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USER" --password-stdin

echo "PR: $TRAVIS_PULL_REQUEST Branch: $TRAVIS_TAG"

if [[ -n "$TRAVIS_TAG" ]]; then
    docker build -t "templum/rabbitmq-connector:$TRAVIS_TAG" .
    docker push "templum/rabbitmq-connector:$TRAVIS_TAG"
fi

if [[ "$TRAVIS_PULL_REQUEST" = false ]]; then
    if [[ "$TRAVIS_BRANCH" = "master" ]]; then
        docker build -t "templum/rabbitmq-connector:latest" .
        docker push "templum/rabbitmq-connector:latest"
        docker build -t "templum/rabbitmq-connector:release" .
        docker push "templum/rabbitmq-connector:release"
    fi

    if [[ "$TRAVIS_BRANCH" = "develop" ]]; then
        docker build -t "templum/rabbitmq-connector:develop" .
        docker push "templum/rabbitmq-connector:develop"
    fi
else
    docker build -t "templum/rabbitmq-connector:pr-$TRAVIS_PULL_REQUEST" .
    docker push "templum/rabbitmq-connector:pr-$TRAVIS_PULL_REQUEST"
fi