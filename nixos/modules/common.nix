{ pkgs, inputs, ... }:

{
  nix.registry = {
    np.flake = inputs.nixpkgs;
    npu.flake = inputs.nixpkgs-unstable;
    ll.flake = inputs.llm-agents;
    llp.flake = inputs.llm-agents-pinned;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.substituters = [ "https://cache.nixos.org" ];
  nix.settings.trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];

  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  programs.vim = {
    enable = true;
    defaultEditor = true;
  };


  environment.systemPackages = with pkgs; [
    python312
    git
    gh
  ];
}
