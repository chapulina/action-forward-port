#!/bin/bash

set -x
set -e

echo ::group::Install tools
apt update
apt install -y git
echo ::endgroup::

echo "$GITHUB_WORKSPACE"
cd "$GITHUB_WORKSPACE"

FROM_BRANCH=$1
TO_BRANCH=$2
echo "From: $FROM_BRANCH"
echo "To: $TO_BRANCH"

echo ::group::Checkout
PORT_BRANCH=port_${FROM_BRANCH}_${TO_BRANCH}_`date '+%Y-%m-%d'`
git fetch
git checkout ${FROM_BRANCH}
git checkout -t origin/${TO_BRANCH}
git checkout -b ${PORT_BRANCH}
echo ::endgroup::

echo ::group::Merge
git merge ${FROM_BRANCH}
git add --all
echo ::endgroup::

echo ::group::Commit and push
git commit -c user.name="osrf-triage" -c user.email="sim@openrobotics.org" \
    --author="osrf-triage <sim@openrobotics.org>" \
    -sam"${FROM_BRANCH} ➡️  ${TO_BRANCH}"
git push ${PORT_BRANCH}
echo ::endgroup::
