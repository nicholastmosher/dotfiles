{ pkgs, config, ... }:
{
  home.stateVersion = "22.11";
  imports = [
    ../modules/alacritty.nix
    ../modules/direnv.nix
    ../modules/fzf.nix
    ../modules/git.nix
    ../modules/kind.nix
    ../modules/nushell.nix
    ../modules/packages.nix
    ../modules/starship.nix
    ../modules/tmux.nix
    ../modules/vscode.nix
    # ../modules/zellij.nix
    ../modules/zsh.nix
  ];

  home.packages = [
    pkgs.rustup
    pkgs.kafkactl
    pkgs.graphviz
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };
  home.sessionPath = [
    "${config.home.homeDirectory}/.cargo/bin"
    "${config.home.homeDirectory}/.local/bin"
  ];

  programs.git = {
    enable = true;
    userEmail = "nick.mosher@ditto.live";
    userName = "Nick Mosher";
  };

  programs.starship.settings = {
    kubernetes.disabled = false;
  };
}
