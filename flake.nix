{
  description = "Sample Haskell project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    idr2nix.url = "git+https://git.sr.ht/~thatonelutenist/idr2nix?ref=trunk";
    idr2nix.inputs.nixpkgs.follow = "nixpkgs";
    idris.url = "github:idris-lang/Idris2";
    idirs.inputs.nixpkgs.follow = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils/main";
  };

  outputs = { nixpkgs, flake-utils, idris, ... }:
    let
      supportedSystems = [ "x86_64-linux" ];

      outputs-overlay = system: pkgs: prev: {
        idris-playground-shell = pkgs.mkShell {
          nativeBuildInputs = [
            idris.packages."${system}".default
          ];
        };
      };
    in
    flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (outputs-overlay system) ];
        };
      in
      {
        devShells = {
          default = pkgs.idris-playground-shell;
        };
      }
    );
}
