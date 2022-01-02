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
      plugins = [ "sudo" "git" "kubectl" ];
    };
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
