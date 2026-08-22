{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.system.bluetooth;
in {
  options.system.bluetooth = {
    enable = lib.mkEnableOption "enable bluetooth module";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [blueman];
    hardware.bluetooth.enable = true;
  };
}
