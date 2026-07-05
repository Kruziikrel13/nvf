{
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
in
{
  options.vim.utility.smart-backspace.enable = mkEnableOption "smart-backspace";
}
