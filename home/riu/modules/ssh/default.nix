{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      bastion.proxyJump = "none";
      "*" = {
        proxyJump = "bastion";
        identityFile = "/run/secrets/ssh_private_key";
        identitiesOnly = true;
      };
    };
  };
}
