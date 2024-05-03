{
  description = "kubetools-1_27_1";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        fetch = { url, hash }:
          pkgs.fetchzip {
            url =
              "https://storage.googleapis.com/kubebuilder-tools/kubebuilder-tools-1.27.1-${url}.tar.gz";
            hash = hash;
          };

        kubebuilder = let
          platformMapping = {
            x86_64-linux = "linux-amd64";
            aarch64-linux = "linux-arm64";
            x86_64-darwin = "darwin-amd64";
            aarch64-darwin = "darwin-arm64";
          };
          shaMapping = {
            aarch64-linux =
              "sha256-M9CgiHugLh7t7ulWGp4psRCtihBDxmBxqmSw5UHxKj4=";
            aarch64-darwin =
              "sha256-ohXx4OPoEmBBojHmuS8V+V1JbXkKud8kKPjniQhKv1w=";
            x86_64-linux =
              "sha256-gJ/BvTbzKa8Wx2Hleyy2GEe+EOnlKvqT/6xuPu1nvB0=";
          };
        in {
          sha = builtins.getAttr system shaMapping;
          path = builtins.getAttr system platformMapping;
        };
      in {
        packages.default = fetch {
          hash = kubebuilder.sha;
          url = kubebuilder.path;
        };
      });
}
