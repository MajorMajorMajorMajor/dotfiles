#!/usr/bin/env bash
set -euo pipefail

extra_nix_config='experimental-features = nix-command flakes'
export NIX_CONFIG="${NIX_CONFIG:+$NIX_CONFIG$'\n'}$extra_nix_config"

target="${1:-}"
if [[ -z "$target" && -r /etc/nixos-rebuild-target ]]; then
  target="$(tr -d '\n' < /etc/nixos-rebuild-target)"
fi

if [[ -z "$target" ]]; then
  echo "No target specified and /etc/nixos-rebuild-target is missing." >&2
  echo "Usage: rebuild <target>" >&2
  exit 1
fi

if [[ -n "${REBUILD_FLAKE_ROOT:-}" ]]; then
  flake_root="$REBUILD_FLAKE_ROOT"
elif [[ -f "$PWD/nixos/flake.nix" ]]; then
  flake_root="$PWD/nixos"
elif [[ -f "$PWD/flake.nix" ]]; then
  flake_root="$PWD"
elif [[ -f "$HOME/dotfiles/nixos/flake.nix" ]]; then
  flake_root="$HOME/dotfiles/nixos"
else
  echo "Could not find flake root. Set REBUILD_FLAKE_ROOT." >&2
  exit 1
fi

exec sudo NIX_CONFIG="$NIX_CONFIG" nixos-rebuild switch --flake "$flake_root#$target"
