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

      # Start the daemon through our systemd user unit before launching the GUI.
      # maestral_qt can start the daemon itself, but only waits around 30s;
      # starting it here preserves the GNOME wrapper while avoiding login autostart.
      ${systemd}/bin/systemctl --user start maestral.service || true

      attempts=0
      while ! ${maestral}/bin/maestral status >/dev/null 2>&1; do
        attempts=$((attempts + 1))
        [ "$attempts" -ge 120 ] && break
        ${coreutils}/bin/sleep 0.5
      done

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
  ];

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Keep a systemd user unit available for on-demand startup from the maestral_qt wrapper.
  systemd.user.services.maestral = {
    description = "Maestral Dropbox sync daemon";
    serviceConfig = {
      ExecStart = "${pkgs.maestral}/bin/maestral start --foreground";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };

  systemd.user.services.calibre-dedrm = {
    description = "Install Calibre DeDRM plugins";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = toString (pkgs.writeShellScript "calibre-install-dedrm" ''
        ${pkgs.calibre}/bin/calibre-customize -a ${dedrm-plugins}/DeDRM_plugin.zip
        ${pkgs.calibre}/bin/calibre-customize -a ${dedrm-plugins}/Obok_plugin.zip
      '');
    };
  };

  programs.firefox.enable = true;
  programs.chromium.enable = true;
  programs.vscode.enable = true;
}
