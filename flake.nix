{
  description = "sample end user scala project nix flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        inherit (lib) attrValues;

        jdk = "jdk11";

        packageOverrides = p: {
          sbt = p.sbt.override {
            jre = p.${jdk};
          };
        };

        pkgs = import nixpkgs { inherit system; config = packageOverrides; };
        lib = pkgs.lib;

      in rec {
        defaultPackage = pkgs.hello;

        devShell = with pkgs; mkShell {
          name = "scala";
          buildInputs = [
            coursier
            sbt
            pkgs.${jdk}
            metals
          ];
        };
    });
}
