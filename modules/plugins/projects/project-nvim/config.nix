{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.nvim.dag) entryAnywhere;
  inherit (lib.nvim.lua) toLuaObject;

  cfg = config.vim.projects.project-nvim;
in
{
  config = mkIf cfg.enable {
    vim.startPlugins = [
      "project-nvim"
    ];

    vim.pluginRC.project-nvim = entryAnywhere ''
      require('project').setup(${toLuaObject cfg.setupOpts})
    '';

    vim.filetree.nvimTree.setupOpts = {
      respect_buf_cwd = true;
      update_focused_file = {
        enable = true;
        update_root = true;
      };
    };
  };
}
