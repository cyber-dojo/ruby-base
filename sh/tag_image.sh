#!/bin/bash -Eeu

sh_dir() { echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"; }
source "$(sh_dir)/image_name.sh"
source "$(sh_dir)/image_tag.sh"
source "$(sh_dir)/git_commit_sha.sh"

# - - - - - - - - - - - - - - - - - - - - - - - -
tag_image()
{
  local -r image="$(image_name)"
  local -r tag="$(image_tag)"
  docker tag "${image}:latest" "${image}:${tag}"
  echo "$(git_commit_sha)"
  echo "${tag}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
tag_image
