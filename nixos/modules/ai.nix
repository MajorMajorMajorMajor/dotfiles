{ pkgs, llm-agents, ... }:

{
  environment.systemPackages = [
    llm-agents.packages.${pkgs.system}.pi
    pkgs.claude-code
  ];
}
