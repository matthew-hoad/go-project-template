{
  description = "Go project with gomod2nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gomod2nix.url = "github:nix-community/gomod2nix";
    gomod2nix.inputs.nixpkgs.follows = "nixpkgs";
    gomod2nix.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, gomod2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        gomod2nix-pkg = gomod2nix.packages.${system}.default;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            go_1_25
            gomod2nix-pkg
            gopls
            gotestsum
            gofumpt
            delve
            golangci-lint
          ];

          shellHook = ''
            # Ensure go.mod and go.sum are up to date
            if [ -f go.mod ]; then
              echo "Checking Go modules..."
              go mod tidy
              
              # Generate or update gomod2nix.toml
              echo "Updating gomod2nix..."
              gomod2nix
            fi
          '';
        };
      }
    );
}