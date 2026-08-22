{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.home.browsers.chromium;
  browserVersion = lib.versions.major pkgs.ungoogled-chromium.version;
in {
  options.home.browsers.chromium = {
    enable = lib.mkEnableOption "enable ungoogled-chromium module";
  };

  config = lib.mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      extensions = import ./extensions.nix {inherit browserVersion;};
      dictionaries = with pkgs.hunspellDictsChromium; [en_US];
      commandLineArgs = [
        "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder"
        "--ignore-gpu-blocklist"
        "--enable-gpu-rasterization"
        "--enable-zero-copy"
      ];
    };
  };
}
