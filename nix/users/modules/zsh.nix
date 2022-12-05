{ config, ... }:
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    initExtra = ''
      source ~/.alias
      source /etc/static/bashrc &>/dev/null
      [[ -f "${config.home.homeDirectory}/.path.private" ]] && source "${config.home.homeDirectory}/.path.private"
    '';

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
      "]" = "xdg-open";
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
}

