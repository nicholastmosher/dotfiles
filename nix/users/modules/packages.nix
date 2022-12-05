{ pkgs, ... }:

{
  # Include only packages that are also darwin-compatible
  home.packages = with pkgs; [
    fd
    jq
    bat
    exa
    git
    vim
    xsv
    file
    ipfs
    tmux
    wget
    procs
    tokei
    watch
    ripgrep
    asciinema
  ];
}
