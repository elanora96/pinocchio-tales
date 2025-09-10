{
  description = "Tales From Pinocchio";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      perSystem =
        {
          pkgs,
          ...
        }:
        let
          name = "pinocchio-tales";
        in
        {
          devShells.default = pkgs.mkShell {
            name = "${name}-shell";
            buildInputs = with pkgs; [ zola ];
          };
        };
    };
}
