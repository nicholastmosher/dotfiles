{ pkgs, ... }:

{
  # Include only packages that are also darwin-compatible
  home.packages = with pkgs; [
    fd
    jq
    bat
    exa
    git
    xsv
    file
    ipfs
    wget
    procs
    tokei
    watch
    ripgrep
    asciinema
  ];
}
