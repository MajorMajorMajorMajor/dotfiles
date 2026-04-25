{ pkgs-unstable, ... }:

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

}
