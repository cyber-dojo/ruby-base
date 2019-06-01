#!/bin/bash
set -e

readonly SH_DIR="$( cd "$( dirname "${0}" )" && pwd )/sh"
readonly MY_NAME=ruby-base

"${SH_DIR}/build_docker_images.sh"
