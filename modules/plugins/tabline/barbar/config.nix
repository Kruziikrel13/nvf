{
  config,
  options,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.nvim.binds) mkKeymap;
  inherit (lib.nvim.dag) entryAnywhere;
  inherit (lib.nvim.lua) toLuaObject;
  inherit (lib.generators) mkLuaInline;

  cfg = config.vim.tabline.barbar;
  mappings = options.vim.tabline.barbar.mappings;
in
{
  config = mkIf cfg.enable {
    vim = {
      startPlugins = [ "barbar" ];
      pluginRC.barbar = entryAnywhere ''
        require('barbar').setup(${toLuaObject cfg.setupOpts})
      '';

      keymaps = [
        (mkKeymap "n" cfg.mappings.closeCurrent "<CMD>BufferClose<CR>" {
          desc = mappings.closeCurrent.description;
          silent = true;
          noremap = false;
        })
        (mkKeymap "n" cfg.mappings.cycleNext "<CMD>BufferNext<CR>" {
          desc = mappings.cycleNext.description;
          silent = true;
          noremap = false;
        })
        (mkKeymap "n" cfg.mappings.cyclePrevious "<CMD>BufferPrevious<CR>" {
          desc = mappings.cyclePrevious.description;
          silent = true;
          noremap = false;
        })
        (mkKeymap "n" cfg.mappings.sortByLanguage "<CMD>BufferOrderByLanguage<CR>" {
          desc = mappings.sortByLanguage.description;
          silent = true;
          noremap = false;
        })
        (mkKeymap "n" cfg.mappings.sortByDirectory "<CMD>BufferOrderByDirectory<CR>" {
          desc = mappings.sortByDirectory.description;
          silent = true;
          noremap = false;
        })
        (mkKeymap "n" cfg.mappings.sortById "<CMD>BufferOrderByBufferNumber<CR>" {
          desc = mappings.sortById.description;
          silent = true;
          noremap = false;
        })
        (mkKeymap "n" cfg.mappings.closeAllButVisible "<CMD>BufferCloseAllButVisible<CR>" {
          desc = mappings.closeAllButVisible.description;
          silent = true;
          noremap = false;
        })
      ];

      autocmds = mkIf cfg.persistedCompat [
        {
          event = [ "User" ];
          pattern = [ "PersistedSavePre" ];
          callback = mkLuaInline ''
            function()
              vim.api.nvim_exec_autocmds('User', { pattern = "SessionSavePre" })
            end
          '';
        }
      ];
    };
  };
}
