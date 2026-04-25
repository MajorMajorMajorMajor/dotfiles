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
  nix.settings.substituters = [ "https://cache.nixos.org" ];
  nix.settings.trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    # Required to build GVFS with Google Drive backend support.
    "libsoup-2.74.3"
  ];

  environment.variables = {
    VISUAL = "vim";
  };

  environment.shellAliases = {
    lg = "lazygit";
  };

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

    python312
    git
    gh

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
