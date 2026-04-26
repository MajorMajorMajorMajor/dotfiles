# vim: set tabstop=2 shiftwidth=2 expandtab:
{ pkgs, pkgs-unstable, ... }:

{
  programs.niri = {
    enable = true;
    package = pkgs-unstable.niri;
  };

  # niri itself doesn't manage Xwayland; run xwayland-satellite as a user service for X11 apps.
  systemd.user.services.xwayland-satellite = {
    description = "Xwayland outside your Wayland compositor";
    bindsTo = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    requisite = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "notify";
      ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
      StandardOutput = "journal";
      Restart = "on-failure";
      RestartSec = "1s";
    };
  };

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    dgop.package = pkgs-unstable.dgop;
  };

  environment.systemPackages = 
    with pkgs-unstable; [
      fuzzel
    ];

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
