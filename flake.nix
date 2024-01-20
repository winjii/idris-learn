{
  description = "Sample Haskell project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    flake-utils.url = "github:numtide/flake-utils/main";
    idr2nix.url = "git+https://git.sr.ht/~thatonelutenist/idr2nix?ref=trunk";
    idr2nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, flake-utils, idr2nix, ... }:
    # let
    #   supportedSystems = [ "x86_64-linux" ];
    # in flake-utils.lib.eachSystem supportedSystems (system:
    #   let
    #     pkgs = import nixpkgs {
    #       inherit system;
    #     };
    #   in {
    #     devShells = {
    #       default = pkgs.mkShell {
    #         buildInputs = [ idr2nix.packages."${system}".idr2nix ];
    #       };
    #     };
    #   }
    # );
    idr2nix.idris.single {
      packageName = "hello";
      sources = builtins.fromJSON (builtins.readFile ./hello.json);
      ipkg = "hello.ipkg";
      src = ./.;
      idris2api = true;
    };
}
