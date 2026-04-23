{ pkgs, pkgs-unstable, ... }:

{
  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.gnome-browser-connector.enable = true;

  # Use unstable GVFS with Google backend enabled.
  services.gvfs.package = pkgs-unstable.gvfs.override {
    gnomeSupport = true;
    googleSupport = true;
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "dvorak";
  };

  console.keyMap = "dvorak";

  services.printing.enable = true;

  hardware.sane.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  environment.systemPackages = with pkgs; [
    simple-scan # GNOME scanning app (frontend for SANE scanners)
    sane-backends # scanner drivers/backends used by simple-scan and other scan tools
    smplayer
    pkgs-unstable.discord
    gitg
    baobab
  ];

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.firefox.enable = true;
  programs.chromium.enable = true;
  programs.vscode.enable = true;
}
