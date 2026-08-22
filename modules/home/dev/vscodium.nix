{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.home.dev.vscodium;
in {
  options.home.dev.vscodium = {
    enable = lib.mkEnableOption "enable vscodium";
  };

  config = lib.mkIf cfg.enable {
    programs.vscodium = {
      enable = lib.mkDefault true;
      package = lib.mkDefault pkgs.vscodium;
      profiles.default.enableExtensionUpdateCheck = lib.mkDefault true; # in hm options says it only works for default profile and applies to all profiles
    };
  };
}
