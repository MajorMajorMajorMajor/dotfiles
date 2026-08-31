{ pkgs, pkgs-unstable, ... }:

{
  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.gnome-browser-connector.enable = true;
}
