# vim: set tabstop=2 shiftwidth=2 expandtab:
{ pkgs, pkgs-unstable, ... }:

{
  programs.niri = {
    enable = true;
    package = pkgs-unstable.niri;
  };

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    dgop.package = pkgs-unstable.dgop;
  };

  environment.systemPackages =
    (with pkgs-unstable; [
      fuzzel
    ])
    ++ [
      pkgs.xwayland-satellite
    ];

  # GNOME-like Super behavior in niri:
  # - tap left Super => send F24 (bound in niri config to overview)
  # - hold left Super => keep acting as Super modifier
  services.keyd = {
    enable = true;
    keyboards.default.settings = {
      main = {
        leftmeta = "overload(meta, f24)";
      };
    };
  };

  # Lightweight Wayland login manager for a compositor-first setup.
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
    };
  };
}
