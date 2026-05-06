#!/usr/bin/env bash
set -euo pipefail
repoarg="${1:?Usage: gh-commits OWNER/REPO[@BRANCH] [PATH] [N]}"
branch="${repoarg#*@}"
[[ "$branch" == "$repoarg" ]] && branch=""
repo="${repoarg%%@*}"
path="${2:-}"
n="${3:-10}"
url="repos/$repo/commits?per_page=$n"
[[ -n "$path" ]] && url="$url&path=$path"
[[ -n "$branch" ]] && url="$url&sha=$branch"
gh api "$url" --jq '.[] | "\(.sha[:8]) \(.commit.author.date[:10]) \(.commit.message | split("\n")[0])"'
