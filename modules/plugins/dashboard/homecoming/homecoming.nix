{ lib, ... }:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.nvim.types) mkPluginSetupOption;
in
{
  options.vim.dashboard.homecoming = {
    enable = mkEnableOption "homecoming dashboard";
    setupOpts = mkPluginSetupOption { };
  };
}
