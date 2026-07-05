{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.meta) getExe;
  inherit (lib.nvim.binds) mkKeymap;
  inherit (lib.strings) optionalString;
  integration-config = (pkgs.formats.yaml { }).generate "terminal-integration.yml" {
    os.editPreset = "nvim-remote";
    gui.nerdFontsVersion = 3;
  };

  # Wraps lazygit with a config file to ensure it automatically integrates with neovim
  lazygit = pkgs.symlinkJoin {
    name = "lazygit";
    paths = [ pkgs.lazygit ];
    buildInputs = [ pkgs.makeWrapper ];
    meta.mainProgram = "lazygit";
    postBuild = ''
      wrapProgram $out/bin/lazygit --set LG_CONFIG_FILE ${integration-config}
    '';
  };

  cfg = config.vim.terminal.ergoterm;
in
{
  config = mkIf cfg.enable {
    vim.lazy.plugins.ergoterm-nvim = {
      package = "ergoterm-nvim";
      setupModule = "ergoterm";
      inherit (cfg) setupOpts;
      after = ''
        local ergoterm = require("ergoterm")

        ergoterm:new({
          name = "default",
          layout = "below",
          auto_scroll = true,
          sticky = true,
          size = {
            below = "30%",
          },
          -- stylua: ignore
          on_open = function(term)
            local bufnr = term:get_state("bufnr")

            vim.keymap.set("t", "<Esc>", function() vim.cmd.stopinsert() end, { buffer = bufnr })
            vim.keymap.set("n", "q", function() term:close() end, { buffer = bufnr })
            vim.keymap.set("n", "<Esc>", function() term:close() end, { buffer = bufnr })
          end,
        })

        ${optionalString cfg.lazygitIntegration ''
          ergoterm:new({
            name = "git",
            cmd = "${getExe lazygit}",
            layout = "float",
            sticky = true,
            float_winblend = 0,
            watch_files = true,
            on_close = function()
              -- fixes insert mode bug
              vim.defer_fn(function()
                vim.cmd.stopinsert()
              end, 150)
            end,
          })
        ''}
      '';
      keys = [
        (mkKeymap [ "x" "n" "t" ] cfg.mappings.open "require('ergoterm').get_by_name('default'):toggle()" {
          desc = cfg.mappings.open.description;
          lua = true;
        })

        (mkIf cfg.lazygitIntegration (
          mkKeymap [ "x" "n" "t" ] cfg.mappings.lazygit "require('ergoterm').get_by_name('git'):toggle" {
            desc = cfg.mappings.lazygit.description;
            lua = true;
          }
        ))
      ];
    };
  };
}
