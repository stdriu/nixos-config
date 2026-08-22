{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.system.shell;
in {
  options.system.shell = {
    enable = lib.mkEnableOption "enable shell module";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh.enable = true;

    users.defaultUserShell = pkgs.zsh;
    environment.shells = [pkgs.zsh];
  };
}
