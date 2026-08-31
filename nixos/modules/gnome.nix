{ pkgs, pkgs-unstable, ... }:

{
  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.gnome-browser-connector.enable = true;

  # xwayland 24.1.10 (stable) has a tablet "slave" device regression that
  # breaks Krita pen input under Wayland. 24.1.11 (unstable) fixes it.
  # Override only mutter's xwayland input so the rest of the GNOME stack
  # stays on stable; this triggers a local mutter rebuild.
  nixpkgs.overlays = [
    (final: prev: {
      mutter = prev.mutter.override { xwayland = pkgs-unstable.xwayland; };
    })
  ];

  warnings = pkgs.lib.optional
    (builtins.compareVersions pkgs.xwayland.version "24.1.11" >= 0)
    "gnome.nix: stable xwayland is now ≥24.1.11 — remove the mutter overlay and pkgs-unstable.xwayland workaround";
}
