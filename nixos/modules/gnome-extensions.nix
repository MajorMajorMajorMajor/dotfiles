{ pkgs, ... }:

let
  extensions = with pkgs.gnomeExtensions; [
    places-status-indicator
    clipboard-indicator
    extension-list
    top-bar-organizer
  ];
in
{
  environment.systemPackages = extensions;

  services.desktopManager.gnome = {
    extraGSettingsOverridePackages = [
      pkgs.gnome-shell
    ];

    # NOTE: this override locks the enabled-extensions list — toggling extensions
    # via the GNOME Extensions app won't persist across boots. Edit this list instead.
    extraGSettingsOverrides = ''
      [org.gnome.shell]
      enabled-extensions=[${builtins.concatStringsSep "," (map (ext: "'${ext.extensionUuid}'") extensions)}]
    '';
  };
}
