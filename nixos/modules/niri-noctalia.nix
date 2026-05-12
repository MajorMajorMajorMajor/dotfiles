# vim: set tabstop=2 shiftwidth=2 expandtab:
#
# Noctalia is autostarted via `spawn-at-startup "noctalia-shell"` in the
# user's niri config.kdl rather than the upstream NixOS module — the
# module's only autostart path is a systemd user service that upstream
# has deprecated. We just install the package here.
{ inputs, pkgs, ... }:

let
  noctalia-shell =
    inputs.noctalia-shell.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  environment.systemPackages = [ noctalia-shell ];
}
