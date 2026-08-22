{lib, ...}: let
  inherit (lib) mkDefault;
  kb = 1024;
  mb = 1024 * kb;
  gb = 1024 * mb;
in {
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = mkDefault true;
    trusted-users = mkDefault ["root" "@wheel"];
    min-free = mkDefault (2 * gb);
    max-free = mkDefault (10 * gb);
    cores = mkDefault 0;
    max-jobs = mkDefault "auto";
    keep-outputs = mkDefault false;
    keep-derivations = mkDefault false;
    warn-dirty = mkDefault true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
