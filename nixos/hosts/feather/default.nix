{ lib, ... }:

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
    extraGroups = [ "networkmanager" "wheel" "scanner" "lp" ];
  };

  nix.settings.substituters = [
    "https://linux-surface.cachix.org"
    "https://surface-nix.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "linux-surface.cachix.org-1:dorigzlDDV6AacaQLVHHYU8scAzBIlwAhGz/JQ8fVeI="
    "surface-nix.cachix.org-1:RsYTWm0eGHpJO6FBL9l/pZMHBYHcI9siaPVNM2oHD+8="
  ];

  hardware.sane.brscan4 = {
    enable = true;
    netDevices = {
      brother7860 = {
        model = "MFC-7860DW";
        nodename = "BRN001BA9EEACDD.local";
      };
    };
  };

  # TODO: try enabling touchscreen support
  # microsoft-surface.ipts.enable = true;

  services.openssh.enable = true;

  nix.settings.max-jobs = 1;

  systemd.services.nix-daemon.serviceConfig = {
    IOSchedulingClass = lib.mkForce "idle";
    Nice = 19;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.dirty_ratio" = 5;
    "vm.dirty_background_ratio" = 2;
  };

  system.stateVersion = "25.11";
}
