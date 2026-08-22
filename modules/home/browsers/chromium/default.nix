{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.home.browsers.chromium;
in {
  imports = [./chromium.nix];

  config = lib.mkIf cfg.enable {
    xdg.mimeApps = {
      enable = lib.mkDefault true;
      defaultApplications = lib.mkIf (config.home.browsers.defaultBrowser == "chromium") {
        "text/html" = "chromium-browser.desktop";
        "x-scheme-handler/http" = "chromium-browser.desktop";
        "x-scheme-handler/https" = "chromium-browser.desktop";
        "x-scheme-handler/about" = "chromium-browser.desktop";
        "x-scheme-handler/unknown" = "chromium-browser.desktop";
      };
    };
  };
}
