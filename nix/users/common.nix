{ config, lib, pkgs, ... }:

{
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";

  home.packages = with pkgs; [
    exa
    bat
    tokei
    xsv
    fd
    ripgrep
    tmux
    jq
    procs
    signal-desktop
    spotify
    gnome3.gnome-tweaks
    xclip
  ];

  home.sessionVariables = {
    EDITOR = "kak";
  };

  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];

  home.file.".ideavimrc".source = ../../.ideavimrc;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    nix-direnv.enableFlakes = true;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;

    shellAliases = {
      ls = "exa";
      sl = "exa";
      l = "exa -labh --git";
      la = "exa -labh --git";
      al = "exa -labh --git";
      law = "watch -cn0.2 exa -labh --git";
      glgg = "git log --graph --abbrev-commit --decorate --color=always --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all | less -S";
      glggw = "watch -xcn0.2 git log --graph --abbrev-commit --decorate --color=always --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all --color";
      tp = "tee >(xclip -sel clipboard)";
      tpp = "xclip -sel clipboard -o";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "aws"
        "docker"
        "fd"
        "git"
        "kubectl"
        "npm"
        "ripgrep"
        "rust"
        "sudo"
        "tmux"
        "vi-mode"
      ];
    };
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      # Set tmux to xterm-256color
      set -g default-terminal "screen-256color"

      # Mouse Mode
      set -g mouse on

      # Set tmux colors
      set -g status-bg blue
      set -g pane-active-border-style fg=blue

      # Larger scrollback buffer
      set-option -g history-limit 5000

      # Detect vim
      is_vim='echo "#{pane_current_command}" | grep -iqE "(^|\/)g?(view|n?vim?x?)(diff)?$"'

      # <c-HJKL> moves between panes unless in vim
      bind -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
      bind -n C-j if-shell "$is_vim" "send-keys c-j" "select-pane -D"
      bind -n C-k if-shell "$is_vim" "send-keys c-k" "select-pane -U"
      bind -n C-l if-shell "$is_vim" "send-keys c-l" "select-pane -R"

      # Allow clearing screen with ctrl-l by using <prefix> C-l
      bind C-l send-keys 'C-l'

      # Allow navigating between windows with C-\ and C-n.
      bind -n C-n next

      # Use C-b / as search-up
      set-window-option -g mode-keys vi
      bind-key / copy-mode \; send-key ?

      # New panes open to the current working directory.
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      # Start window numbers at 1 to match keyboard order with tmux window order.
      set -g base-index 1
      set-window-option -g pane-base-index 1

      # Renumber windows sequentially after closing any of them.
      set -g renumber-windows on

      # Instant escape time (for vim)
      set -sg escape-time 0

      # My convention for servers is that every time starting tmux, use tmux attach.
      # If a session exists, it will attach to it. If not, it runs this .tmux.conf,
      # starts a new session, and attaches to it.
      # new-session #Uncomment on server devices.
    '';
  };

  programs.exa.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f";
  };

  programs.gh.enable = true;

  programs.git = {
    delta = {
      enable = true;
      options = {
        side-by-side = true;
        plus-style = ''syntax "#003700"'';
      };
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      nix_shell.symbol = "❄️ ";
    };
  };

  programs.kakoune.enable = true;

  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    shell.program = "tmux";
    colors = {
      primary = {
        background = "0x1f1f1f";
        foreground = "0xeaeaea";
      };

      cursor = {
        text = "0x000000";
        cursor = "0xffffff";
      };

      normal = {
        black = "0x000000";
        red = "0xf87373";
        green = "0x5efe7e";
        yellow = "0xffeb3d";
        blue = "0x03a9f4";
        magenta = "0xc397d8";
        cyan = "0xdfaf8f";
        white = "0xffffff";
      };
    };
  };

  services.spotifyd.enable = true;

  services.spotifyd.settings.global = {
    username = "codewhisperer97";
    device_name = "nix";
  };

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
    };

    # Custom shortcut: Alacritty = Super+Return
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      "name" = mkString "Alacritty";
      "command" = mkString "alacritty";
      "binding" = mkString "<Super>Return";
    };
  };
}
