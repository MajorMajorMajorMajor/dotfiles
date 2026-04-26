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
