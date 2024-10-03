{
  description = "nix flake for zal0rd";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; };

  outputs = { self, nixpkgs }:
    let
      version = "1.0";

      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in {
      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell {
            nativeBuildInputs = [
              # Development tools
              pkgs.go
              pkgs.pkgconf
              pkgs.xorg.libX11
              pkgs.xorg.libXcursor
              pkgs.xorg.libXrandr
              pkgs.xorg.libXinerama
              pkgs.xorg.libXi
              pkgs.xorg.libXxf86vm
              pkgs.libGL

              # Language servers
              pkgs.gopls
              pkgs.nixd

              # Others tools
              pkgs.scc
            ];
          };
        });
    };
}
