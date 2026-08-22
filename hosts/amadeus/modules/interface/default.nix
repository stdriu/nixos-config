{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.system.interface;
  cursorPackage = inputs.winxp-cursors.packages.${pkgs.stdenv.hostPlatform.system}.default;
  cursorThemeName = "WinXP";
  sddm-weston-wrapper = pkgs.writeShellScript "sddm-weston-wrapper" ''
    WESTON_CONFIG=$(mktemp)

    export XCURSOR_PATH="${cursorPackage}/share/icons:/run/current-system/sw/share/icons"
    export XCURSOR_THEME="${cursorThemeName}"
    export XCURSOR_SIZE=24

    if grep -q "^connected$" /sys/class/drm/card*-HDMI-A-1/status 2>/dev/null; then
      cat <<EOF > $WESTON_CONFIG
    [core]
    xwayland=true

    [output]
    name=HDMI-A-1
    mode=1920x1080@120

    [output]
    name=eDP-1
    mode=off
    EOF
    else
      cat <<EOF > $WESTON_CONFIG
    [core]
    xwayland=true

    [output]
    name=eDP-1
    mode=1360x768@60
    EOF
    fi

    exec ${pkgs.weston}/bin/weston --shell=kiosk-shell.so --config=$WESTON_CONFIG "$@"
  '';
in {
  options.system.interface = {
    enable = lib.mkEnableOption "sddm, hyprland, and gnome-keyring";
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = lib.mkDefault true;
      wayland = {
        enable = lib.mkDefault true;
        compositor = "weston";
      };
      settings = {
        Wayland = {
          CompositorCommand = "${sddm-weston-wrapper}";
        };
        Theme = {
          CursorTheme = cursorThemeName;
        };
      };
    };

    systemd.services.display-manager.environment = {
      XCURSOR_PATH = "${cursorPackage}/share/icons:/run/current-system/sw/share/icons";
      XCURSOR_THEME = cursorThemeName;
      XCURSOR_SIZE = "24";
    };

    programs.qylock = {
      enable = true;
      theme = "nier-automata";
      themeOptions = {
        terraria.backgroundMode = "time";
        Genshin.backgroundMode = "time";
        clockwork.orbital = {
          themeMode = "dark";
          enableWindup = true;
        };
        osu.gameMode = "menu";
      };
    };

    services.gnome.gnome-keyring.enable = lib.mkDefault true;
    services.pcscd.enable = lib.mkDefault true;
    services.dbus.implementation = lib.mkDefault "broker";

    security.pam.services = {
      sddm.enableGnomeKeyring = true;
      login.enableGnomeKeyring = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };

    environment.systemPackages = with pkgs; [
      cursorPackage
      gnome-epub-thumbnailer
      kdePackages.kwindowsystem
      kdePackages.qt5compat
      kdePackages.qtmultimedia
      libsForQt5.qt5ct
      qt5.qtgraphicaleffects
      qt5.qtquickcontrols
      qt5.qtsvg
    ];

    programs.hyprland.enable = lib.mkDefault true;
    programs.hyprland.withUWSM = lib.mkDefault true;
  };
}
