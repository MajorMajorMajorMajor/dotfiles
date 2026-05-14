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

  # xwayland 24.1.10 (stable) has a tablet "slave" device regression that
  # breaks Krita pen input under Wayland. 24.1.11 (unstable) fixes it.
  # Override only mutter's xwayland input so the rest of the GNOME stack
  # stays on stable; this triggers a local mutter rebuild.
  nixpkgs.overlays = [
    (_: prev: {
      mutter = prev.mutter.override { xwayland = pkgs-unstable.xwayland; };
    })
  ];
}
