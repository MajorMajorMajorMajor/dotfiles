# vim: set tabstop=2 shiftwidth=2 expandtab:

{ pkgs, ... }:

let 
  tools = with pkgs; [
    gnome-extension-manager
  ];

  extensions = with pkgs.gnomeExtensions; [
    places-status-indicator
    clipboard-indicator
    extension-list
    top-bar-organizer
  ];

in 
  {
    environment.systemPackages = tools ++ extensions;
  }
