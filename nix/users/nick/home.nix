{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "nick";
  home.homeDirectory = "/home/nick";

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
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "sudo" "git" "kubectl" "tmux" ];
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

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
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

  programs.git = {
    enable = true;
    userEmail = "nicholastmosher@gmail.com";
    userName = "Nick Mosher";
  };
}
