#!/usr/bin/env bash
set -euo pipefail
repo="${1:?Usage: gh-commits OWNER/REPO [PATH] [N]}"
path="${2:-}"
n="${3:-10}"
url="repos/$repo/commits?per_page=$n"
[[ -n "$path" ]] && url="$url&path=$path"
gh api "$url" --jq '.[] | "\(.sha[:8]) \(.commit.author.date[:10]) \(.commit.message | split("\n")[0])"'
