{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnomeExtensions.places-status-indicator
  ];

  services.desktopManager.gnome = {
    extraGSettingsOverridePackages = [
      pkgs.gnome-shell
    ];

    extraGSettingsOverrides = ''
      [org.gnome.shell]
      enabled-extensions=['${pkgs.gnomeExtensions.places-status-indicator.extensionUuid}']
    '';
  };
}
