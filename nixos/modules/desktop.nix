{ pkgs, pkgs-unstable, ... }:

let
  dedrm-archive = pkgs.fetchurl {
    url = "https://github.com/noDRM/DeDRM_tools/releases/download/v10.0.9/DeDRM_tools_10.0.9.zip";
    sha256 = "1nmb38jrrgai7zahbmx9sly850qqvbk3krmpp4g8gp269bwpyvnl";
    name = "DeDRM_tools_10.0.9.zip";
  };
  dedrm-plugins = pkgs.runCommand "dedrm-plugins" { buildInputs = [ pkgs.unzip ]; } ''
    mkdir -p $out
    unzip ${dedrm-archive} DeDRM_plugin.zip Obok_plugin.zip -d $out/
  '';
  install-dedrm = pkgs.writeShellScriptBin "install-dedrm" ''
    echo "Installing DeDRM plugin..."
    ${pkgs.calibre}/bin/calibre-customize -a ${dedrm-plugins}/DeDRM_plugin.zip
    echo "Installing Obok plugin (Kobo DRM)..."
    ${pkgs.calibre}/bin/calibre-customize -a ${dedrm-plugins}/Obok_plugin.zip
    echo "Done. Restart Calibre if it is running."
  '';
in

{
  services.xserver.xkb = {
    layout = "us";
    variant = "dvorak";
  };

  console.keyMap = "dvorak";

  services.printing = {
    enable = true;
    # brlaser drives the Brother MFC-7860DW; scanner configured in hosts/feather via hardware.sane.brscan4.
    drivers = [ pkgs.brlaser ];
  };

  hardware.sane.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  systemd.services.avahi-daemon.serviceConfig.ExecStartPre = "+${pkgs.coreutils}/bin/rm -f /run/avahi-daemon/pid";

  environment.systemPackages = with pkgs; [
    simple-scan # GNOME scanning app (frontend for SANE scanners)
    sane-backends # scanner drivers/backends used by simple-scan and other scan tools
    smplayer
    pkgs-unstable.discord
    pkgs-unstable.signal-desktop
    google-chrome
    libreoffice
    maestral
    (writeShellScriptBin "maestral_qt" ''
      export XDG_DATA_DIRS="${gtk3}/share/gsettings-schemas/${gtk3.name}:${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
      exec ${maestral-gui}/bin/maestral_qt "$@"
    '')
    # Desktop file and icon for GNOME app launcher (writeShellScriptBin provides only the binary)
    (runCommand "maestral-desktop" {} ''
      mkdir -p $out/share/applications $out/share/icons/hicolor/512x512/apps
      cp ${maestral-gui}/share/applications/maestral.desktop $out/share/applications/
      cp ${maestral-gui}/share/icons/hicolor/512x512/apps/maestral.png $out/share/icons/hicolor/512x512/apps/
    '')
    pkgs-unstable.logseq

    pkgs-unstable.alacritty

    calibre
    install-dedrm
  ];

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Start maestral daemon at login so maestral_qt connects instantly instead of timing out
  systemd.user.services.maestral = {
    description = "Maestral Dropbox sync daemon";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.maestral}/bin/maestral start --foreground";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };

  programs.firefox.enable = true;
  programs.chromium.enable = true;
  programs.vscode.enable = true;
}
