{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.home.security;
in {
  options.home.security = {
    enable = lib.mkEnableOption "enables gpg & ssh";
  };

  config = lib.mkIf cfg.enable {
    programs.gpg.enable = lib.mkDefault true;

    services.gpg-agent = {
      enable = lib.mkDefault true;
      enableFishIntegration = lib.mkDefault true;

      pinentry.package = lib.mkDefault pkgs.pinentry-qt;

      defaultCacheTtl = lib.mkDefault 7200;
      maxCacheTtl = lib.mkDefault 28800;
    };
  };
}
