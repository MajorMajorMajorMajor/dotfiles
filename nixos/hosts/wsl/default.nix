{ ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "nixos";
  wsl.wslConf.interop.appendWindowsPath = false;

  system.stateVersion = "25.11";
}
