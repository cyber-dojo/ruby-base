#!/bin/bash -Eeu

sh_dir()
{
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
}

git_commit_sha()
{
  echo $(cd "$(sh_dir)/.." && git rev-parse HEAD)
}
