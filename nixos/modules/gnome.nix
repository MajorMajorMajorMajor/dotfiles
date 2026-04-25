{ pkgs, pkgs-unstable, ... }:

{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.gnome-browser-connector.enable = true;

  # Use unstable GVFS with Google backend enabled.
  services.gvfs.package = pkgs-unstable.gvfs.override {
    gnomeSupport = true;
    googleSupport = true;
  };

  environment.systemPackages = with pkgs; [
    simple-scan
    gitg
    baobab
  ];
}
