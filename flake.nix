{
  description = "Tales From Pinocchio";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [ inputs.treefmt-nix.flakeModule ];
      perSystem =
        {
          pkgs,
          ...
        }:
        let
          name = "pinocchio-tales";
          buildInputs = with pkgs; [
            nodejs
            zola
          ];
        in
        {
          devShells.default = pkgs.mkShell {
            inherit buildInputs;
            name = "${name}-shell";
          };
          treefmt = {
            # Used to find the project root
            projectRootFile = "flake.nix";
            programs = {
              # JS and CSS
              biome = {
                enable = true;
                settings = {
                  files = {
                    includes = [ "!package_abridge.js" ];
                  };
                };
              };
              # Markdown
              mdformat.enable = true;
              # Nix
              nixfmt.enable = true;
              # TOML
              taplo.enable = true;
            };
          };
        };
    };
}
