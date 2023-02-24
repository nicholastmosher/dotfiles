{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kind
    kubectl
    kubecolor
  ];

  programs.zsh.shellAliases = {
    kubectl = "kubecolor";
  };
}
