{
  description = "Tales From Pinocchio";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    self.submodules = true;
    systems.url = "github:nix-systems/default";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [ inputs.treefmt-nix.flakeModule ];
      perSystem =
        {
          pkgs,
          lib,
          ...
        }:
        let
          name = "pinocchio-tales";
          pname = name;

          src = ./.;
          npmRoot = src;

          importNpmLock = pkgs.importNpmLock;
          nodejs = pkgs.nodejs;
          zola = pkgs.zola;

          meta = {
            description = "We post scary stories for our followers";
            homepage = "https://talesofpinocchio.netlify.app";
            license = lib.licenses.mit;
            maintainers = with lib.maintainers; [ elanora96 ];
            platforms = lib.platforms.all;
          };

          nativeBuildInputs = [ zola ];
          buildInputs = nativeBuildInputs ++ [
            nodejs
          ];
        in
        {
          packages.default = pkgs.buildNpmPackage {
            inherit
              name
              pname
              src
              meta
              nativeBuildInputs
              buildInputs
              ;

            npmDeps = importNpmLock { inherit npmRoot; };
            npmConfigHook = importNpmLock.npmConfigHook;

            installPhase = ''
              mkdir -p $out
              cp -r ./public $out/public
            '';
          };
          devShells.default = pkgs.mkShell {
            inherit buildInputs;
            name = "${name}-shell";
            packages = [
              importNpmLock.hooks.linkNodeModulesHook
              nodejs
            ];
            npmDeps = importNpmLock.buildNodeModules {
              inherit nodejs npmRoot;
            };
          };
          treefmt = {
            projectRootFile = "flake.nix"; # Used to find the project root
            programs = {
              biome = {
                enable = true;
                settings.files.includes = [ "!package_abridge.js" ];
              };
              mdformat.enable = true;
              nixfmt.enable = true;
              taplo.enable = true;
            };
          };
        };
    };
}
