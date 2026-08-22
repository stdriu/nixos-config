{self, ...}: {
  imports = [
    "${self}/modules/home/browsers/firefox"
    "${self}/modules/home/browsers/chromium"
    "${self}/modules/home/xdg"
    "${self}/modules/home/theme"
    "${self}/modules/home/dev"
  ];

  home.theme.enable = true;
  home.xdg.enable = true;
  home.dev.enable = true;
  home.browsers.enable = true;
  home.browsers.chromium.enable = true;
  home.matugen.enable = true;
  home.hyprland.enable = true;
  home.kanshi.enable = true;
  home.kitty.enable = true;
  home.media.enable = true;
  home.dev.vscodium.enable = true;
}
