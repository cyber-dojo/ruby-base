#!/bin/bash -Eeu

sh_dir() { echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"; }
source "$(sh_dir)/assert_equal.sh"
source "$(sh_dir)/git_commit_sha.sh"
source "$(sh_dir)/image_name.sh"
source "$(sh_dir)/image_sha.sh"

# - - - - - - - - - - - - - - - - - - - - - - - -
build_docker_images()
{
  docker build \
    --build-arg COMMIT_SHA="$(git_commit_sha)" \
    --tag "$(image_name)" \
    "$(sh_dir)/../app"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
build_docker_images
assert_equal SHA "$(git_commit_sha)" "$(image_sha)"
