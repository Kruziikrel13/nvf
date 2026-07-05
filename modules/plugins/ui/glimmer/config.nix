{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;

  cfg = config.vim.ui.tiny-glimmer;
in
{
  config = mkIf cfg.enable {
    vim.lazy.plugins.tiny-glimmer = {
      package = "tiny-glimmer-nvim";
      setupModule = "tiny-glimmer";
      inherit (cfg) setupOpts;
    };
  };
}
