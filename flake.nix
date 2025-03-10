{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";

    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs-terraform.url = "github:stackbuilders/nixpkgs-terraform";

    devenv.url = "github:cachix/devenv";

    git-hooks.url = "github:cachix/git-hooks.nix";

    treefmt.url = "github:numtide/treefmt-nix";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } { imports = [ ./nix ]; };

  nixConfig = {
    extra-substituters = [
      "https://devenv.cachix.org"
      "https://nixpkgs-terraform.cachix.org"
    ];
    extra-trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "nixpkgs-terraform.cachix.org-1:8Sit092rIdAVENA3ZVeH9hzSiqI/jng6JiCrQ1Dmusw="
    ];
  };
}
