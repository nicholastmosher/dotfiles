{ pkgs, ... }:
{
  imports = [
    ../modules/alacritty.nix
    ../modules/direnv.nix
    ../modules/fzf.nix
    ../modules/git.nix
    ../modules/packages.nix
    ../modules/starship.nix
    ../modules/tmux.nix
    ../modules/vscode.nix
    ../modules/zsh.nix
  ];

  home.file.".config/zellij/config.kdl".source = ../../../.config/zellij/config.kdl;
  home.packages = [
    pkgs.rustup
  ];

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
  ];

  programs.git = {
    enable = true;
    userEmail = "nicholastmosher@gmail.com";
    userName = "Nick Mosher";
  };
}
