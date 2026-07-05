{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;
  inherit (lib.nvim.dag) entryAnywhere;
  inherit (lib.nvim.lua) toLuaObject;
  inherit (lib.generators) mkLuaInline;

  cfg = config.vim.dashboard.homecoming;
in
{
  config = mkIf cfg.enable {
    vim = {
      startPlugins = [ "homecoming-nvim" ];
      pluginRC.homecoming-nvim = entryAnywhere ''
        require('homecoming-nvim').setup(${toLuaObject cfg.setupOpts})
      '';

      autocmds = [
        {
          event = [ "VimResized" ];
          callback = mkLuaInline ''
            function()
              if vim.fn.expand("%:p") == "homecoming://Dashboard" then
                vim.cmd("Homecoming")
              end
            end
          '';
        }
      ];
    };
  };
}
