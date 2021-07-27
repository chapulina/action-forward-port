#!/bin/bash

set -eu

apt update
apt install -y git

git fetch
git checkout ${INPUT_FROM_BRANCH}
git checkout ${INPUT_TO_BRANCH}
git checkout -b port_${INPUT_FROM_BRANCH}_${INPUT_TO_BRANCH}_`date '+%Y-%m-%d'`
git merge ${INPUT_FROM_BRANCH}
git add --all
git commit -c user.name="osrf-triage" -c user.email="sim@openrobotics.org" \
    --author="osrf-triage" \
    -sam"${INPUT_FROM_BRANCH} ➡️  ${INPUT_TO_BRANCH}"
git push
