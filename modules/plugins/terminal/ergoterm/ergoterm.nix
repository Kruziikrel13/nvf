{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.nvim.types) mkPluginSetupOption;
  inherit (config.vim.lib) mkMappingOption;
in
{
  options.vim.terminal.ergoterm = {
    enable = mkEnableOption "ergoterm as a replacement to built-in terminal command";
    lazygitIntegration = mkEnableOption "lazygit wrapped in config env for native neovim support";

    mappings = {
      open = mkMappingOption "Open ergoterm" "<c-t>";
      lazygit = mkMappingOption "Open lazygit" "<leader>gg";
    };

    setupOpts = mkPluginSetupOption "ErgoTerm" { };
  };
}
