#!/bin/bash -Eeu

on_ci()
{
  set +u
  [ -n "${CIRCLECI}" ]
  local -r result=$0
  set -u
  [ "${result}" == '0' ]
}
