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
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
    "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    "linux-surface.cachix.org-1:dorigzlDDV6AacaQLVHHYU8scAzBIlwAhGz/JQ8fVeI="
    "surface-nix.cachix.org-1:RsYTWm0eGHpJO6FBL9l/pZMHBYHcI9siaPVNM2oHD+8="
  ];

  environment.variables = {
    VISUAL = "vim";
  };

  environment.shellAliases = {
    lg = "lazygit";
  };

  # Required for ad-hoc `nix shell`/`nix run` with unfree packages;
  # nixpkgs.config in flake.nix only covers system builds.
  environment.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  programs.vim = {
    enable = true;
    defaultEditor = true;
  };


  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "rebuild" ''
      target="''${1:-$(cat /etc/nixos-rebuild-target)}"
      exec sudo nixos-rebuild switch --flake ~/dotfiles/nixos#"$target"
    '')

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

    # my preferred tools
    screen
    bat

    # hipster stuff
    lazygit
    neovim
    neovide # sick gui for neovim

    # voice for Claude... kinda sucks
    sox
  ];
}
