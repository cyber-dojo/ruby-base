#!/bin/bash -Eeu

on_ci()
{
  set +u
  [ -n "${CIRCLECI}" ]
  local -r result=$?
  set -u
  [ "${result}" == '0' ]
}
