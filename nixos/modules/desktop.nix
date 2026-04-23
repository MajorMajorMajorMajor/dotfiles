{ pkgs, pkgs-unstable, ... }:

{
  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

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
    simple-scan
    sane-backends
    smplayer
    pkgs-unstable.discord
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
