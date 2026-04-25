{ pkgs, ... }:

{
  environment.systemPackages = with pkgs.gnomeExtensions; [
    places-status-indicator
    clipboard-indicator
    extension-list
    top-bar-organizer
  ];
}
