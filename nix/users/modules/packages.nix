{ pkgs, ... }:

{
  # Include only packages that are also darwin-compatible
  home.packages = with pkgs; [
    fd
    jq
    sd
    bat
    exa
    git
    k9s
    nil
    vim
    xsv
    file
    ipfs
    skim
    tmux
    wget
    yarn
    ngrok
    procs
    taplo
    tokei
    watch
    nodejs
    zoxide
    ripgrep
    marksman
    rnix-lsp
    asciinema
    shellcheck
    nodePackages.bash-language-server
  ];
}
