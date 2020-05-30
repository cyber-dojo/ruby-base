#!/bin/bash -Eeu

readonly ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly TMP_DIR="$(mktemp -d /tmp/ruby-base.XXXXXXX)"
remove_tmp_dir() { rm -rf "${TMP_DIR}" > /dev/null; }
trap remove_tmp_dir INT EXIT

# - - - - - - - - - - - - - - - - - - - - - - - -
build_docker_images()
{
  docker build \
    --build-arg COMMIT_SHA="$(git_commit_sha)" \
    --tag "$(image_name)" \
    "${ROOT_DIR}/app"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
assert_equal()
{
  local -r name="${1}"
  local -r expected="${2}"
  local -r actual="${3}"
  echo "expected: ${name}='${expected}'"
  echo "  actual: ${name}='${actual}'"
  if [ "${expected}" != "${actual}" ]; then
    echo "ERROR: unexpected ${name} inside image ${IMAGE}:latest"
    exit 42
  fi
}

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
image_name()
{
  echo cyberdojo/ruby-base
}

# - - - - - - - - - - - - - - - - - - - - - - - -
git_commit_sha()
{
  echo $(cd "${ROOT_DIR}" && git rev-parse HEAD)
}

# - - - - - - - - - - - - - - - - - - - - - - - -
image_tag()
{
  local -r sha="$(git_commit_sha)"
  echo "${sha:0:7}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
image_sha()
{
  docker run --rm $(image_name):latest sh -c 'echo ${SHA}'
}

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
on_ci_trigger_dependent_images()
{
  if ! on_ci; then
    echo 'not on CI so not triggering dependent images'
    return
  fi
  echo 'on CI so triggering dependent images'
  curl_trigger_script
  local -r from_org=cyber-dojo
  local -r from_repo=ruby-base
  local -r from_sha="$(git_commit_sha)"
  local -r to_org=cyber-dojo
  local -r to_repos=rack-base
  $(trigger_script_path) \
    "${from_org}" "${from_repo}" "${from_sha}" \
    "${to_org}" "${to_repos}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
curl_trigger_script()
{
  local -r raw_github_org=https://raw.githubusercontent.com/cyber-dojo
  local -r repo=cyber-dojo
  local -r branch=master
  local -r path=sh/circle-ci
  local -r url="${raw_github_org}/${repo}/${branch}/${path}/$(trigger_script_name)"
  curl --fail --output $(trigger_script_path) --silent "${url}"
  chmod 700 "$(trigger_script_path)"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
trigger_script_path()
{
  echo "${TMP_DIR}/$(trigger_script_name)"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
trigger_script_name()
{
  echo github_automated_commit_push.sh
}

# - - - - - - - - - - - - - - - - - - - - - - - -
on_ci()
{
  set +u
  [ -n "${CIRCLECI}" ]
  local -r result=$?
  set -u
  [ "${result}" == '0' ]
}

# - - - - - - - - - - - - - - - - - - - - - - - -
build_docker_images
assert_equal SHA "$(git_commit_sha)" "$(image_sha)"
tag_image
on_ci_publish_tagged_image
on_ci_trigger_dependent_images
