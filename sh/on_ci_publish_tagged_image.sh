#!/bin/bash -Eeu

sh_dir() { echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"; }
source "$(sh_dir)/image_name.sh"
source "$(sh_dir)/image_tag.sh"
source "$(sh_dir)/on_ci.sh"

# - - - - - - - - - - - - - - - - - - - - - - - -
on_ci_publish_tagged_image()
{
  if ! on_ci; then
    echo 'not on CI so not publishing tagged image'
    return
  fi
  echo 'on CI so publishing tagged image'
  local -r image="$(image_name)"
  local -r tag="$(image_tag)"
  # DOCKER_USER, DOCKER_PASS are in ci context
  echo "${DOCKER_PASS}" | docker login --username "${DOCKER_USER}" --password-stdin
  docker push ${image}:latest
  docker push ${image}:${tag}
  docker logout
}

# - - - - - - - - - - - - - - - - - - - - - - - -
on_ci_publish_tagged_image
