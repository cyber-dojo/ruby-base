FROM  alpine:3.8
LABEL maintainer=jon@jaggersoft.com

RUN apk --update --no-cache add \
    bash \
    ruby-bundler \    
    ruby-dev

ARG             HOME=/app
COPY Gemfile  ${HOME}/
WORKDIR       ${HOME}

RUN apk --update add --virtual build-dependencies build-base \
  && echo "gem: --no-rdoc --no-ri" > ~/.gemrc \
  && bundle config --global silence_root_warning 1 \
  && bundle install \
  && gem clean \
  && apk del build-dependencies build-base \
  && rm -vrf /var/cache/apk/*
