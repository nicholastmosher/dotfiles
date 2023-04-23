{ config, ... }:
{
  home.file.".alias".source = ../../../home/.alias;
  home.file.".alias.osx".source = ../../../home/.alias.osx;
  home.file.".path".source = ../../../home/.path;
  home.file.".config/helix/config.toml".source = ../../../home/.config/helix/config.toml;
  home.file.".config/helix/themes/onedark_custom.toml".source = ../../../home/.config/helix/themes/onedark_custom.toml;
  home.file.".config/helix/themes/ayu_mirage_custom.toml".source = ../../../home/.config/helix/themes/ayu_mirage_custom.toml;

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

