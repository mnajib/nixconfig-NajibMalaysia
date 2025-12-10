# overlays/grafito.nix
final: prev: {
  grafito = prev.stdenvNoCC.mkDerivation {
    pname = "grafito";
    version = "v0.4.0"; # Change here when upgrading
    src = prev.fetchurl {
      url = "https://github.com/ralsina/grafito/releases/download/v0.4.0/grafito-linux-amd64";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Replace with real hash
    };
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/grafito
      chmod +x $out/bin/grafito
    '';
  };
}

