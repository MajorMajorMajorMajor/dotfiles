{ pkgs, llm-agents, ... }:

{
  nix.settings.substituters = [ "https://numtide.cachix.org" ];
  nix.settings.trusted-public-keys = [ "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE=" ];

  environment.systemPackages = [
    llm-agents.packages.${pkgs.system}.pi
    pkgs.claude-code
  ];
}
