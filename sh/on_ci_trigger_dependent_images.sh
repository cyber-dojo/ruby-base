#!/bin/bash -Eeu

sh_dir() { echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"; }
source "$(sh_dir)/git_commit_sha.sh"
source "$(sh_dir)/on_ci.sh"

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
  curl -O --silent --fail "${url}"
  chmod 700 "$(trigger_script_path)"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
trigger_script_path()
{
  echo "./$(trigger_script_name)"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
trigger_script_name()
{
  echo github_automated_commit_push.sh
}

# - - - - - - - - - - - - - - - - - - - - - - - -
on_ci_trigger_dependent_images
