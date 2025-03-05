{
  description = "A Nix-flake-based RStudio Analysis environment";
  # use: nix develop

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self , nixpkgs ,... }: let
    # system should match the system you are running on
    # system = "x86_64-linux";
    system = "aarch64-darwin";
  in {
    devShells."${system}".default = let
      pkgs = import nixpkgs {
        inherit system;
      };
    in pkgs.mkShell {
      # create an environment with required R Packages
      packages = with pkgs; [
        curlFull
        rPackages.curl
        (rstudioWrapper.override{ 
          packages = with rPackages; [ tidyverse drc ]; # add new R packages here to get tied in
          }
        )
      ];

      shellHook = ''
        echo "RStudio Analysis Shell - ${system}"
      '';
    };
  };
}