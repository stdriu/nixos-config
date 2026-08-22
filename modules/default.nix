{
  flake.modules = {
    system = {
      audio = import ./system/audio;
      bluetooth = import ./system/bluetooth;
      boot = import ./system/boot;
      browsers = import ./system/browsers;
      dev = import ./system/dev;
      fileSystem = import ./system/fileSystem;
      fonts = import ./system/fonts;
      gaming = import ./system/gaming;
      interface = import ./system/interface;
      nix = import ./system/nix;
      shell = import ./system/shell;
      utils = import ./system/utils;
      virtualisation = import ./system/virtualisation;
      secrets = import ./system/secrets;
      sysdep = import ./system/sysdep;
    };

    home = {
      security = import ./home/security;
      browsers = {
        firefox = import ./home/browsers/firefox;
        chromium = import ./home/browsers/chromium;
      };
      media = import ./home/media;
      dev = import ./home/dev;
      xdg = import ./home/xdg;
      kanshi = import ./home/kanshi;
      wm-utils = import ./home/wm-utils;
      theme = import ./home/theme;
      matugen = import ./home/matugen;
      hyprland = import ./home/hyprland;
      kitty = import ./home/kitty;
    };
  };
}
