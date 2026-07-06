{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.nvim.binds) mkKeymap;
  inherit (lib.generators) mkLuaInline;

  cfg = config.vim.tabline.barbar;
in
{
  config = mkIf cfg.enable {
    vim = {
      lazy.plugins.barbar = {
        package = "barbar";
        setupModule = "barbar";
        inherit (cfg) setupOpts;

        keys = [
          (mkKeymap "n" cfg.mappings.closeCurrent "<CMD>BufferClose<CR>" {
            desc = cfg.mappings.closeCurrent.description;
            silent = true;
            noremap = false;
          })
          (mkKeymap "n" cfg.mappings.cycleNext "<CMD>BufferNext<CR>" {
            desc = cfg.mappings.cycleNext.description;
            silent = true;
            noremap = false;
          })
          (mkKeymap "n" cfg.mappings.cyclePrevious "<CMD>BufferPrevious<CR>" {
            desc = cfg.mappings.cyclePrevious.description;
            silent = true;
            noremap = false;
          })
          (mkKeymap "n" cfg.mappings.sortByLanguage "<CMD>BufferOrderByLanguage<CR>" {
            desc = cfg.mappings.sortByLanguage.description;
            silent = true;
            noremap = false;
          })
          (mkKeymap "n" cfg.mappings.sortByDirectory "<CMD>BufferOrderByDirectory<CR>" {
            desc = cfg.mappings.sortByDirectory.description;
            silent = true;
            noremap = false;
          })
          (mkKeymap "n" cfg.mappings.sortById "<CMD>BufferOrderByBufferNumber<CR>" {
            desc = cfg.mappings.sortById.description;
            silent = true;
            noremap = false;
          })
          (mkKeymap "n" cfg.mappings.closeAllButVisible "<CMD>BufferCloseAllButVisible<CR>" {
            desc = cfg.mappings.closeAllButVisible.description;
            silent = true;
            noremap = false;
          })
        ];
      };

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
