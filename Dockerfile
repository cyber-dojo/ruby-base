FROM ruby:alpine
LABEL maintainer=jon@jaggersoft.com

RUN apk --update --upgrade --no-cache add \
    bash \
    tini

# Fix for snyk problem https://security.snyk.io/vuln/SNYK-ALPINE317-OPENSSL-3188632
RUN apk upgrade libcrypto3 libssl3

WORKDIR /app
COPY Gemfile .

RUN apk --update --upgrade add --virtual build-dependencies build-base \
  && echo "gem: --no-rdoc --no-ri" > ~/.gemrc \
  && bundle install \
  && gem clean \
  && apk del build-dependencies build-base \
  && rm -vrf /var/cache/apk/*

ARG COMMIT_SHA
ENV SHA=${COMMIT_SHA}
