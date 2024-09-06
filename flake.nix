{
  description = "Tokio website PDF generator";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    tokio-website = {
      url = "github:tokio-rs/website";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, tokio-website }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "tokio-tutorial-pdf";
          src = tokio-website;

          nativeBuildInputs = with pkgs; [
            pandoc
            texliveSmall
          ];

          buildPhase = ''
            ${pkgs.pandoc}/bin/pandoc \
              <(cat \
                  content/tokio/index.md \
                  content/tokio/tutorial/index.md \
                  content/tokio/tutorial/setup.md \
                  content/tokio/tutorial/hello-tokio.md \
                  content/tokio/tutorial/spawning.md \
                  content/tokio/tutorial/shared-state.md \
                  content/tokio/tutorial/channels.md \
                  content/tokio/tutorial/io.md \
                  content/tokio/tutorial/framing.md \
                  content/tokio/tutorial/async.md \
                  content/tokio/tutorial/select.md \
                  content/tokio/tutorial/streams.md \
                  content/tokio/glossary.md) \
                -o tokio-rs-tutorial.pdf
          '';

          installPhase = ''
            mkdir -p $out
            cp tokio-rs-tutorial.pdf $out/
          '';
        };
      }
    );
}

