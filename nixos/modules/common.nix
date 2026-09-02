{ pkgs, inputs, ... }:

{
  nix.registry = {
    np.flake = inputs.nixpkgs;
    npu.flake = inputs.nixpkgs-unstable;
    ll.flake = inputs.llm-agents;
    llp.flake = inputs.llm-agents-pinned;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "@wheel" ];
  nix.settings.substituters = [
    "https://cache.nixos.org"                # upstream NixOS cache
    "https://numtide.cachix.org"             # numtide: prebuilt llm-agents.nix derivations (claude-code, pi)
    "https://cache.numtide.com"
    "https://linux-surface.cachix.org"       # linux-surface: kernel patches and surface-control (feather only, harmless elsewhere)
    "https://surface-nix.cachix.org"
    "https://pebble.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
    "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    "linux-surface.cachix.org-1:dorigzlDDV6AacaQLVHHYU8scAzBIlwAhGz/JQ8fVeI="
    "surface-nix.cachix.org-1:RsYTWm0eGHpJO6FBL9l/pZMHBYHcI9siaPVNM2oHD+8="
    "pebble.cachix.org-1:aTqwT2hR6lGggw/rPISRcHZctDv2iF7ewsVxf3Hq6ow="
  ];

  environment.variables = {
    VISUAL = "vim";
    LESS = "--mouse --RAW-CONTROL-CHARS --quit-if-one-screen --no-init";
  };

  environment.shellAliases = {
    lg = "lazygit";
    ccl = "nix run ll#claude-code -- --dangerously-skip-permissions";
  };

  # Required for ad-hoc `nix shell`/`nix run` with unfree packages;
  # nixpkgs.config in flake.nix only covers system builds.
  environment.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  programs.bash.interactiveShellInit = ''
    set -o vi
    nixos-delete-generations() {
      sudo nix-env --delete-generations "$@" --profile /nix/var/nix/profiles/system
    }
  '';

  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  # workaround for build error on python3.12-3.12.13-doc
  #   https://github.com/NixOS/nixpkgs/issues/499166
  #   https://discourse.nixos.org/t/build-fail-migrating-from-25-11-to-26-05-relating-to-python-and-sphinx/77959/2
  documentation.doc.enable = false;

  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "rebuild" (builtins.readFile ../scripts/rebuild.sh))
    (writeShellScriptBin "gh-commits" (builtins.readFile ../scripts/gh-commits.sh))

    killall

    # dev tools
    python312
    git
    gh

    # multimedia
    (pkgs.ffmpeg-full.override { 
      withUnfree = true; 
      withRtmp = true;
    })

    # ai preferred tools
    ripgrep
    fd
    jq
    tmux

    # nix tools
    nh
    nix-tree

    # my preferred tools
    screen
    bat
    stow

    # hipster stuff
    lazygit
    neovim
    neovide # sick gui for neovim

    # voice for Claude... kinda sucks
    sox
  ];
}
