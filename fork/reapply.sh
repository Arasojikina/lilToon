#!/bin/bash
# Usage: bash fork/reapply.sh <upstream tag>   (run at the repo root, on the fork's main fork branch)
set -e
V=$1; [ -n "$V" ] || { echo "usage: $0 <tag>"; exit 1; }
cp fork/pom-loop-cap.patch /tmp/pom.patch; cp FORK_NOTES.md /tmp/FORK_NOTES.md; cp fork/reapply.sh /tmp/reapply.sh
git fetch https://github.com/lilxyzw/lilToon.git "refs/tags/$V:refs/tags/$V" --no-tags
git checkout -b "fork-$V" "$V"
git apply /tmp/pom.patch || git apply --3way /tmp/pom.patch
mkdir -p fork && cp /tmp/pom.patch fork/pom-loop-cap.patch && cp /tmp/reapply.sh fork/reapply.sh && cp /tmp/FORK_NOTES.md FORK_NOTES.md
grep -n "min(LIL_POM_DETAIL" Assets/lilToon/Shader/Includes/lil_common_functions.hlsl
git add -A && git commit -m "Cap POM loop at 64 (fork) on $V"
echo "check, then: git tag $V-fork1 && git push origin fork-$V $V-fork1"
