{ pkgs, llm-agents, llm-agents-pinned, ... }:

{
  environment.systemPackages = [
    llm-agents.packages.${pkgs.system}.pi
    llm-agents-pinned.packages.${pkgs.system}.claude-code
  ];
}
