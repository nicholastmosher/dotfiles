{ lib, ... }:
{
  dconf.settings = with lib.hm.gvariant; {
    # Keyboard repeat rate
    "org/gnome/desktop/peripherals/keyboard" = {
      "repeat-interval" = mkUint32 15;
      "delay" = mkUint32 200;
    };

    # Set CapsLock to Escape, set Shift+CapsLock to CapsLock
    "org/gnome/desktop/input-sources" = {
      "xkb-options" = mkArray type.string [ "terminate:ctrl_alt_bksp" "caps:escape_shifted_capslock" ];
    };

    # Gnome shell settings
    "org/gnome/shell" = {
      "enabled-extensions" = mkArray type.string [ "vertical-overview@RensAlthuis.github.com" ];
      "favorite-apps" = mkArray type.string [ "firefox.desktop" "org.gnome.Nautilus.desktop" ];
    };

    # Gnome window shortcuts
    "org/gnome/desktop/wm/keybindings" = {
      "switch-to-workspace-up" = mkArray type.string [ "<Super>k" ];
      "switch-to-workspace-down" = mkArray type.string [ "<Super>j" ];
      "move-to-workspace-up" = mkArray type.string [ "<Super><Shift>k" ];
      "move-to-workspace-down" = mkArray type.string [ "<Super><Shift>j" ];
      "close" = mkArray type.string [ "<Super>q" ];
      "minimize" = mkEmptyArray type.string;
      "switch-input-source" = mkEmptyArray type.string;
      "switch-input-source-backward" = mkEmptyArray type.string;
      "toggle-maximized" = mkArray type.string [ "<Shift><Super>space" ];
      "toggle-overview" = mkArray type.string [ "<Super>space" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      # Custom shortcut: Lock = Super+`
      "screensaver" = mkArray type.string [ "<Primary>grave" ];

      # Custom shortcut link: Alacritty -> custom0
      "custom-keybindings" = mkArray type.string [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];

      # Allow screen recordings to run 1h rather than 30s
      "max-screencast-length" = mkUint32 3600;
    };

    # Custom shortcut: Alacritty = Super+Return
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      "name" = mkString "Alacritty";
      "command" = mkString "alacritty";
      "binding" = mkString "<Super>Return";
    };
  };
}

