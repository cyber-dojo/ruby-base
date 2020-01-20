FROM alpine:3.10
# 3.10 gives simplecov 0.17.1, Ruby 2.5.7p206
# 3.11 gives simplecov 0.17.1, Ruby 2.6.5p114 which has a coverage bug (found in the differ repo)
# See https://github.com/colszowka/simplecov/issues/802
LABEL maintainer=jon@jaggersoft.com

RUN apk --update --upgrade --no-cache add \
    bash \
    ruby-bundler \
    ruby-dev

WORKDIR /app
COPY Gemfile .

RUN apk --update --upgrade add --virtual build-dependencies build-base \
  && echo "gem: --no-rdoc --no-ri" > ~/.gemrc \
  && bundle config --global silence_root_warning 1 \
  && bundle install \
  && gem clean \
  && apk del build-dependencies build-base \
  && rm -vrf /var/cache/apk/*

ARG COMMIT_SHA
ENV SHA=${COMMIT_SHA}
