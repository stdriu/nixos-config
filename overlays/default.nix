{inputs, ...}: final: prev: {
  sf-mono-liga-bin = prev.stdenvNoCC.mkDerivation {
    pname = "sf-mono-liga-bin";
    version = "dev";
    src = inputs.sf-mono-liga-src;
    dontConfigure = true;
    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp -R $src/*.otf $out/share/fonts/opentype/
    '';
  };

  doto = prev.stdenvNoCC.mkDerivation {
    pname = "doto";
    version = "1.0";
    src = prev.fetchurl {
      url = "https://raw.githubusercontent.com/google/fonts/main/ofl/doto/Doto%5BROND%2Cwght%5D.ttf";
      hash = "sha256-b0/n03hTuR3zaY2qhM3i2+HJaV2IyYbmUQE0kQM31CY=";
      name = "Doto.ttf";
    };
    dontConfigure = true;
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      cp $src $out/share/fonts/truetype/Doto.ttf
    '';
  };

  discord = prev.discord.override {
    withVencord = true;
    commandLineArgs = "--enable-features=AcceleratedVideoEncoder,AcceleratedVideoDecodeLinuxGL,WaylandWindowDecorations --ignore-gpu-blocklist";
  };
}
