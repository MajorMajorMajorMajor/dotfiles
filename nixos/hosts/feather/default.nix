{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "feather";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  users.users.stas = {
    isNormalUser = true;
    description = "stas";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://linux-surface.cachix.org"
    "https://surface-nix.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "linux-surface.cachix.org-1:dorigzlDDV6AacaQLVHHYU8scAzBIlwAhGz/JQ8fVeI="
    "surface-nix.cachix.org-1:RsYTWm0eGHpJO6FBL9l/pZMHBYHcI9siaPVNM2oHD+8="
  ];

  environment.systemPackages = with pkgs; [
    baobab
  ];

  # microsoft-surface.ipts.enable = true;  # touchscreen

  services.openssh.enable = true;

  system.stateVersion = "25.11";
}
