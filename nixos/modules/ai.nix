{ pkgs, llm-agents, ... }:

{
  nix.settings.substituters = [
    "https://numtide.cachix.org"
    "https://cache.numtide.com"
  ];
  nix.settings.trusted-public-keys = [
    "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
    "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
  ];

  environment.systemPackages = [
    llm-agents.packages.${pkgs.system}.pi
    pkgs.claude-code
  ];
}
