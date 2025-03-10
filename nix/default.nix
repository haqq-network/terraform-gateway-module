{ lib, inputs, ... }:
{
  imports = [
    inputs.devenv.flakeModule
    inputs.git-hooks.flakeModule
    inputs.treefmt.flakeModule
  ];

  systems = lib.systems.flakeExposed;

  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    {
      devenv.shells.default = {
        enterShell = config.pre-commit.installationScript;

        languages.terraform = {
          enable = true;
          version =
            pkgs.runCommandNoCC "version"
              {
                nativeBuildInputs = with pkgs; [
                  jq
                  json2hcl
                ];
              }
              ''
                json2hcl -reverse <${../versions.tf} |
                  jq -r '.terraform[0].required_version' |
                  cut -d' ' -f2 \
                  >$out
              ''
            |> builtins.readFile
            |> lib.removeSuffix "\n";
        };

        # https://github.com/cachix/devenv/issues/528#issuecomment-1556108767
        containers = lib.mkForce { };
      };

      treefmt.programs = {
        actionlint.enable = true;
        deadnix.enable = true;
        dos2unix.enable = true;
        mdformat.enable = true;
        nixfmt.enable = true;
        statix.enable = true;
        terraform = {
          enable = true;
          inherit (config.devenv.shells.default.languages.terraform) package;
        };
        typos.enable = true;
      };

      pre-commit.settings.hooks = {
        check-merge-conflicts.enable = true;
        convco.enable = true;
        editorconfig-checker.enable = true;
        markdownlint.enable = true;
        tflint.enable = true;
        treefmt.enable = true;
      };
    };
}
