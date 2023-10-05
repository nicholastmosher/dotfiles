{ pkgs, ... }:

{
  # Include only packages that are also darwin-compatible
  home.packages = with pkgs; [
    fd
    jq
    sd
    xh
    yq
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
    navi
    nmap
    skim
    tilt
    tmux
    wget
    yarn
    bacon
    dasel
    gopls
    jdk17
    ngrok
    procs
    taplo
    tokei
    watch
    awscli
    cachix
    dogdns
    mdbook
    nodejs
    zoxide
    kakoune
    ripgrep
    marksman
    rnix-lsp
    asciinema
    inetutils
    shellcheck
    kubelogin-oidc
    kubernetes-helm
    yaml-language-server
    jsonnet-language-server
    jetbrains.idea-community
    nodePackages.bash-language-server
    nodePackages_latest.typescript
    nodePackages_latest.typescript-language-server
  ];
}
