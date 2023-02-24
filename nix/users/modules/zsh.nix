{ config, ... }:
{
  home.file.".alias".source = ../../../home/.alias;
  home.file.".alias.osx".source = ../../../home/.alias.osx;
  home.file.".path".source = ../../../home/.path;

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    initExtra = ''
      source /etc/static/bashrc &>/dev/null
      [[ -f "${config.home.homeDirectory}/.alias" ]] && source "${config.home.homeDirectory}/.alias"
      [[ -f "${config.home.homeDirectory}/.path" ]] && source "${config.home.homeDirectory}/.path"
      [[ -f "${config.home.homeDirectory}/.zshrc.private" ]] && source "${config.home.homeDirectory}/.zshrc.private"
    '';

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
}

