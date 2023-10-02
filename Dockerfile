ARG BASE_IMAGE=ruby:alpine3.18
FROM ${BASE_IMAGE}
LABEL maintainer=jon@jaggersoft.com

# Update curl for https://scout.docker.com/vulnerabilities/id/CVE-2023-38039
# Update procps for https://scout.docker.com/vulnerabilities/id/CVE-2023-4016
# Install util-linux to use `script` to allow ECS exec logging
RUN apk --update --upgrade --no-cache add \
    bash \
    tini \
    procps \
    curl \
    util-linux

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
ENV COMMIT_SHA=${COMMIT_SHA}

# ARGs are reset after FROM See https://github.com/moby/moby/issues/34129
ARG BASE_IMAGE
ENV BASE_IMAGE=${BASE_IMAGE}
