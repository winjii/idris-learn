{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    flake-utils.url = "github:numtide/flake-utils/main";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    with builtins;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        original = pkgs.fetchgit {
          url = "https://github.com/stefan-hoeck/idris2-pack.git";
          rev = "bb0cdc067da0d8be7922e7eb016c3fccd93059cb";
          hash = "sha256-yRpCkNRyIZc7BrX/a0S1ggZ2EIFYCxpFkWAyYYRHfs0=";
          leaveDotGit = true;
        };
      in
        with pkgs;
        {
          packages.default = stdenv.mkDerivation {
            inherit original;
            name = "idris2-pack";
            nativeBuildInputs = [ bash gcc gmp gnumake git chez less glibc ];
            buildCommand = ''
              export PACK_DIR=$PWD/.pack
              export IDRIS2_PREFIX=$PWD/.idris
              cp -r $original ./original
              chmod -R 755 original
              cd original
              make micropack SCHEME=scheme
            '';
          };
        }
    );
}