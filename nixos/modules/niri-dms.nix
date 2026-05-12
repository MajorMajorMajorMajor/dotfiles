# vim: set tabstop=2 shiftwidth=2 expandtab:
{ pkgs-unstable, ... }:

{
  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    dgop.package = pkgs-unstable.dgop;
  };
}
