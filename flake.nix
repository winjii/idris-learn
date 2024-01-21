{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    flake-utils.url = "github:numtide/flake-utils/main";
    idr2nix.url = "git+https://git.sr.ht/~thatonelutenist/idr2nix?ref=trunk";
    idr2nix.inputs.nixpkgs.follows = "nixpkgs";
    idris2-pack.url = "path:./nix/idris2-pack";
    idris2-pack.inputs.nixpkgs.follows = "nixpkgs";
    idris2-pack.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { nixpkgs, flake-utils, idr2nix, idris2-pack, ... }:
    idr2nix.idris.single {
      packageName = "hello";
      sources = builtins.fromJSON (builtins.readFile ./hello.json);
      ipkg = "hello.ipkg";
      src = ./.;
      idris2api = true;
      extraShellPackages = pkgs: [ idris2-pack.packages."${pkgs.system}".default ];
    };
}
