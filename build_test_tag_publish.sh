#!/bin/bash -Eeu

sh_dir() { echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/sh"; }
source "$(sh_dir)/build_docker_images.sh"
source "$(sh_dir)/tag_image.sh"
source "$(sh_dir)/on_ci_publish_tagged_image.sh"
source "$(sh_dir)/on_ci_trigger_dependent_images.sh"
