{ pkgs, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "nixos";
  wsl.wslConf.interop.appendWindowsPath = false;

  environment.systemPackages = with pkgs; [
    bat
  ];

  system.stateVersion = "25.11";
}
