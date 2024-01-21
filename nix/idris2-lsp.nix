{
  lib,
  stdenv,
  fetchFromGitHub,
  idris2,
  ...
}: let
  version = idris2.version;
  _ = lib.asserts.assertOneOf "idris2.version" idris2.version ["0.6.0"];
  src = fetchFromGitHub {
    owner = "idris-community";
    repo = "idris2-lsp";
    rev = "db9c02d13d4665bdae4af0990ea1ab971ad31799";

    # Do not fetch the bundled version of Idris 2
    fetchSubmodules = false;

    sha256 = "sha256-pLh5qBKoi1phvoiaCbpgxs38xaXM1VfD5lQI70I5F38=";
  };
in
  stdenv.mkDerivation {
    name = "idris2-lsp";
    inherit src version;

    buildInputs = [idris2];

    doCheck = false;

    makeFlags = [
      "VERSION_TAG=${version}"
      "PREFIX=$(out)"
    ];

    installTargets = ["install-only"];
  }
