{ lib, rustPlatform, fetchFromSourcehut }:

rustPlatform.buildRustPackage {
  pname = "orilla-run";
  version = "0.1.0";

  src = fetchFromSourcehut {
    owner = "~hokiegeek";
    repo  = "orilla";
    rev   = "REPLACE_ME";      # pin a tag/commit
    hash  = lib.fakeHash;      # `nix build` once, paste real hash back in
  };

  cargoBuildFlags = [ "--bin" "orilla-run" ];
  cargoHash = lib.fakeHash;    # same story, second placeholder

  meta = with lib; {
    description = "Rust-based window manager for the river Wayland compositor";
    homepage = "https://sr.ht/~hokiegeek/orilla/";
    license = licenses.gpl3Only;
    mainProgram = "orilla-run";
  };
}
