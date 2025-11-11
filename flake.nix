{
  description = "Tales From Pinocchio";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.git-hooks-nix.flakeModule
      ];
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

          inherit (pkgs) importNpmLock nodejs zola;

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

          program = pkgs.writeShellScript "run-dev-server.sh" ''
            zola serve
          '';
        in
        {
          apps.default = {
            type = "app";

            program = "${program}";
          };
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
            inherit (importNpmLock) npmConfigHook;

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
          pre-commit.settings.hooks = {
            treefmt.enable = true;
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
              statix.enable = true;
              taplo.enable = true;
            };
          };
        };
    };
}
