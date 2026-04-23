{ pkgs, ... }:

let
  extensions = with pkgs.gnomeExtensions; [
    places-status-indicator
    clipboard-indicator
    extension-list
  ];
in
{
  environment.systemPackages = extensions;

  services.desktopManager.gnome = {
    extraGSettingsOverridePackages = [
      pkgs.gnome-shell
    ];

    extraGSettingsOverrides = ''
      [org.gnome.shell]
      enabled-extensions=[${builtins.concatStringsSep "," (map (ext: "'${ext.extensionUuid}'") extensions)}]
    '';
  };
}
