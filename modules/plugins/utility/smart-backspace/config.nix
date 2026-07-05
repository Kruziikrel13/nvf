{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;

  cfg = config.vim.utility.smart-backspace;
in
{
  config = mkIf cfg.enable {
    vim.lazy.plugins.smart-backspace = {
      package = "smart-backspace";
      event = [ "InsertEnter" ];
    };
  };
}
