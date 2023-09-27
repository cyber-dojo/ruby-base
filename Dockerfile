FROM ruby:alpine3.18
LABEL maintainer=jon@jaggersoft.com

#Update curl for https://scout.docker.com/vulnerabilities/id/CVE-2023-38039
#Update procps for https://scout.docker.com/vulnerabilities/id/CVE-2023-4016
RUN apk --update --upgrade --no-cache add \
    bash \
    tini \
    procps \
    curl

WORKDIR /app
COPY Gemfile .

RUN apk --update --upgrade add --virtual build-dependencies build-base \
  && echo "gem: --no-rdoc --no-ri" > ~/.gemrc \
  && bundle install \
  && gem clean \
  && apk del build-dependencies build-base \
  && rm -vrf /var/cache/apk/*

# Install util-linux to use script to allow ECS exec logging
RUN apk add util-linux

ARG COMMIT_SHA
ENV SHA=${COMMIT_SHA}
