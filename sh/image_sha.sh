#!/bin/bash -Eeu

sh_dir() { echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"; }
source "$(sh_dir)/image_name.sh"

image_sha()
{
  docker run --rm $(image_name):latest sh -c 'echo ${SHA}'
}
