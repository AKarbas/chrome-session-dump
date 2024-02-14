{
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
  };
  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux"];
    eachSystem = nixpkgs.lib.genAttrs supportedSystems;
    forEachSupportedSystem = f:
      eachSystem (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          git
          go
          gnumake
        ];
      };
    });
    formatter = eachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
