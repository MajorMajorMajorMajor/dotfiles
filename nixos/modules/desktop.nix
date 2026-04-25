{ pkgs, pkgs-unstable, ... }:

{
  services.xserver.xkb = {
    layout = "us";
    variant = "dvorak";
  };

  console.keyMap = "dvorak";

  services.printing = {
    enable = true;
    # brlaser drives the Brother MFC-7860DW; scanner configured in hosts/feather via hardware.sane.brscan4.
    drivers = [ pkgs.brlaser ];
  };

  hardware.sane.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  systemd.services.avahi-daemon.serviceConfig.ExecStartPre = "+${pkgs.coreutils}/bin/rm -f /run/avahi-daemon/pid";

  environment.systemPackages = with pkgs; [
    simple-scan # GNOME scanning app (frontend for SANE scanners)
    sane-backends # scanner drivers/backends used by simple-scan and other scan tools
    smplayer
    pkgs-unstable.discord
    pkgs-unstable.signal-desktop
    google-chrome
    libreoffice
    dropbox
    dropbox-cli
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
