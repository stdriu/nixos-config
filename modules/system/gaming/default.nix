{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.system.gaming;
in {
  options.system.gaming = {
    enable = lib.mkEnableOption "enable gaming module";
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
      dedicatedServer.openFirewall = true;
      platformOptimizations.enable = true;
      extraPackages = [pkgs.gamescope];
      extraCompatPackages = [pkgs.proton-ge-bin];
    };

    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };

    programs.gamescope.enable = true;

    environment.systemPackages = with pkgs; [
      heroic
      lutris
      bottles
      prismlauncher
      inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-stable
      r2modman
      vinegar
    ];
  };
}
