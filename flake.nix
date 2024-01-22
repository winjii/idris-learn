{
  description = "Sample Haskell project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    flake-utils.url = "github:numtide/flake-utils/main";
    idr2nix.url = "git+https://git.sr.ht/~thatonelutenist/idr2nix?ref=trunk";
    idr2nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, flake-utils, idr2nix, ... }:
    let
      supportedSystems = [ "x86_64-linux" ];
    in flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        idris2' = pkgs.idris2.overrideAttrs (attrs: {
          postInstall =
            ''
              $out/bin/idris2 --install idris2api.ipkg
            ''
            + (attrs.postInstall or "");
        });
      in {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              idris2'
              (pkgs.callPackage ./nix/idris2-lsp.nix {
                inherit lib stdenv fetchFromGitHub;
                idris2 = idris2';
              })
            ];
            shellHook = ''
              export IDRIS2_PREFIX=${idris2'}
            '';
          };
        };
        packages = {
          default = pkgs.stdenv.mkDerivation {
            name = "idris-learn";
            idris2 = idris2';
            src = ./.;
            buildCommand = ''
              cp -r $src/* .
              $idris2/bin/idris2 --build
              mkdir $out
              cp -r build/exec $out/bin
            '';
          };
        };
      }
    );
}
