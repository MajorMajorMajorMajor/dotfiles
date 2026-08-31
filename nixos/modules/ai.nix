{ pkgs, llm-agents, llm-agents-pinned, ... }:

{
  environment.systemPackages = [
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi
    llm-agents-pinned.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
  ];
}
