{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.system.boot;
in {
  options.system.boot = {
    enable = lib.mkEnableOption "enables grub";
  };

  config = lib.mkIf cfg.enable {
    boot.loader.systemd-boot.enable = false;
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "nodev";
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.useOSProber = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";
  };
}
