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
    nil
    vim
    xsv
    file
    ipfs
    tmux
    wget
    yarn
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
  ];
}
