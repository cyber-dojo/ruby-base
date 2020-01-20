#!/bin/bash -Eeu

sh_dir() { echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"; }
source "$(sh_dir)/git_commit_sha.sh"

image_tag()
{
  local -r sha="$(git_commit_sha)"
  echo "${sha:0:7}"
}
