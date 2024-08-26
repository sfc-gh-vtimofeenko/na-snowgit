{
  description = "Description for the project";

  inputs = {
    nixpkgs-unstable.url = "pinned-nixpkgs-unstable";
    nixpkgs-stable.url = "pinned-nixpkgs-stable";
    nixpkgs.follows = "nixpkgs-stable";

    devshell.url = "pinned-devshell";

    stub.url = "github:VTimofeenko/stub-flake";

    snowcli = {
      url = "github:sfc-gh-vtimofeenko/snowcli-nix-flake";

      inputs = {
        nixpkgs-unstable.follows = "nixpkgs-unstable";
        nixpkgs.follows = "nixpkgs-unstable";
        # development
        devshell.follows = "devshell";
        pre-commit-hooks-nix.url = "pinned-pre-commit-hooks-nix";
        treefmt-nix.url = "pinned-treefmt-nix";
      };
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      imports = [
         inputs.devshell.flakeModule
      ];

      perSystem =
        {
          pkgs,
          inputs',
          # These inputs are unused in the template, but might be useful later
          # , config
          # , self'
          # , system
          ...
        }:
        {
          devshells.default = {
            env = [
              {
                name = "HTTP_PORT";
                value = 8080;
              }
            ];
            commands = [
              {
                help = "print hello";
                name = "hello";
                command = "echo hello";
              }
            ];
            packages = builtins.attrValues {
              inherit (inputs'.snowcli.packages) snowcli-2x;
            };
          };
        };
    };
}
