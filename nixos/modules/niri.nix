{ pkgs, ... }:

{
  programs.niri.enable = true;

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
  };

  # Lightweight Wayland login manager for a compositor-first setup.
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
    };
  };
}
