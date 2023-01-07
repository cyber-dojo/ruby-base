#!/usr/bin/env bash
set -Eeu


export ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SH_DIR="${ROOT_DIR}/sh"

source "${SH_DIR}/kosli.sh"
source "${SH_DIR}/lib.sh"

# - - - - - - - - - - - - - - - - - - - - - - - -
build_docker_images
assert_equal SHA "$(git_commit_sha)" "$(image_sha)"
tag_image
on_ci_publish_tagged_image
on_ci_kosli_declare_pipeline
on_ci_kosli_report_artifact
on_ci_kosli_report_synk_evidence
