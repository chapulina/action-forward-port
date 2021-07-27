#!/bin/bash

set -x
set -e

echo ::group::Install tools
apt update
apt install -y git
echo ::endgroup::

echo "$GITHUB_WORKSPACE"
cd "$GITHUB_WORKSPACE"
ls
echo "$INPUT_REPOSITORY"
cd "$INPUT_REPOSITORY"


echo ::group::Checkout
git fetch
git checkout ${INPUT_FROM_BRANCH}
git checkout ${INPUT_TO_BRANCH}
git checkout -b port_${INPUT_FROM_BRANCH}_${INPUT_TO_BRANCH}_`date '+%Y-%m-%d'`
echo ::endgroup::

echo ::group::Merge
git merge ${INPUT_FROM_BRANCH}
git add --all
echo ::endgroup::

echo ::group::Commit and push
git commit -c user.name="osrf-triage" -c user.email="sim@openrobotics.org" \
    --author="osrf-triage" \
    -sam"${INPUT_FROM_BRANCH} ➡️  ${INPUT_TO_BRANCH}"
git push
echo ::endgroup::
