#!/bin/bash

set -x
set -e

echo ::group::Install tools
apt update
apt install -y git
echo ::endgroup::

echo ::group::Checkout
cd "$GITHUB_WORKSPACE"
git config --global user.email "sim@openrobotics.org"
git config --global user.name "osrf-triage"

FROM_BRANCH=$1
TO_BRANCH=$2
echo "From: $FROM_BRANCH"
echo "To: $TO_BRANCH"

PORT_BRANCH=port_${FROM_BRANCH}_${TO_BRANCH}_`date '+%Y-%m-%d'`
git fetch
git checkout ${FROM_BRANCH}
git checkout -t origin/${TO_BRANCH}
git checkout -b ${PORT_BRANCH}
echo ::endgroup::

echo ::group::Merge
git merge ${FROM_BRANCH} --allow-unrelated-histories || true
git add --all
echo ::endgroup::

echo ::group::Commit and push
git commit -sm"${FROM_BRANCH} ➡️  ${TO_BRANCH}"
git push origin ${PORT_BRANCH}
echo ::endgroup::
