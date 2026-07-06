{ lib, ... }:
let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types)
    bool
    enum
    listOf
    str
    ;
  inherit (lib.nvim.types) mkPluginSetupOption;

  animations = [
    "fade"
    "reverse_fade"
    "bounce"
    "left_to_right"
    "pulse"
    "rainbow"
  ];
in
{
  options.vim.ui.tiny-glimmer = {
    enable = mkEnableOption "tiny glimmer";

    setupOpts = mkPluginSetupOption "tiny-glimmer" {
      enabled = mkOption {
        type = bool;
        default = true;
        example = false;
      };
      autoreload = mkOption {
        type = bool;
        default = false;
        example = true;
        description = "reload highlights when colorscheme changes";
      };
      overwrite = {
        auto_map = mkOption {
          type = bool;
          default = true;
          example = false;
          description = "automatically map keys to overwrite operations";
        };

        yank = {
          enabled = mkOption {
            type = bool;
            default = true;
            example = false;
          };
          default_animation = mkOption {
            type = enum animations;
            default = "fade";
          };
        };

        search = {
          enabled = mkOption {
            type = bool;
            default = false;
            example = true;
          };
          default_animation = mkOption {
            type = enum animations;
            default = "pulse";
          };
        };

        paste = {
          enabled = mkOption {
            type = bool;
            default = true;
            example = false;
          };
          default_animation = mkOption {
            type = enum animations;
            default = "reverse_fade";
          };
        };

        undo = {
          enabled = mkOption {
            type = bool;
            default = false;
            example = true;
          };
          default_animation = mkOption {
            type = enum animations;
            default = "fade";
          };
        };

        redo = {
          enabled = mkOption {
            type = bool;
            default = false;
            example = true;
          };
          default_animation = mkOption {
            type = enum animations;
            default = "fade";
          };
        };
      };

      presets.pulsar.enabled = mkOption {
        type = bool;
        default = false;
        example = true;
      };

      hijack_ft_disabled = mkOption {
        type = listOf str;
        default = [
          "alpha"
          "snacks_dashboard"
        ];
        example = [ "dashboard" ];
      };
    };
  };
}
