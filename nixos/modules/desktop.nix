{ pkgs, pkgs-unstable, ... }:

{
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
    pkgs-unstable.signal-desktop
    google-chrome
    libreoffice
    dropbox
    pkgs-unstable.logseq
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
