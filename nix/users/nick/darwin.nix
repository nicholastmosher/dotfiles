{ pkgs, ... }:
{
  home.stateVersion = "22.11";
  imports = [
    ../modules/alacritty.nix
    ../modules/direnv.nix
    ../modules/fzf.nix
    ../modules/git.nix
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
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };
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
