{ pkgs, ... }:

{
  # Include only packages that are also darwin-compatible
  home.packages = with pkgs; [
    fd
    jq
    sd
    xh
    bat
    exa
    git
    k9s
    nil
    vim
    xsv
    file
    glow
    ipfs
    kind
    nmap
    skim
    tilt
    tmux
    wget
    yarn
    ngrok
    procs
    taplo
    tokei
    watch
    awscli
    dogdns
    nodejs
    zoxide
    ripgrep
    marksman
    rnix-lsp
    asciinema
    inetutils
    shellcheck
    kubernetes-helm
    nodePackages.bash-language-server
  ];
}
