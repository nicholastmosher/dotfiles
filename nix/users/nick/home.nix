{ config, lib, pkgs, ... }:

{
  home.stateVersion = "20.09";
  imports = [
    ./modules/alacritty.nix
    ./modules/direnv.nix
    ./modules/fzf.nix
    ./modules/git.nix
    ./modules/gnome.nix
    ./modules/nushell.nix
    ./modules/packages.nix
    ./modules/starship.nix
    ./modules/tmux.nix
    ./modules/vscode.nix
    ./modules/zellij.nix
    ./modules/zsh.nix
  ];

  home.packages = with pkgs; [
    vim
    xclip
    ripgrep
    spotify
    alacritty
    signal-desktop
    gnome3.gnome-tweaks
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.exa.enable = true;
  programs.git = {
    enable = true;
    userEmail = "nicholastmosher@gmail.com";
    userName = "Nick Mosher";
    extraConfig = {
      safe.directory = "/home/nick/.dotfiles";
    };
  };

  home.file.".gnupg/gpg.conf".source = ../../home/.gnupg/gpg.conf;
  home.file.".gnupg/gpg-agent.conf".source = ../../home/.gnupg/gpg-agent.conf;
  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
  ];
}
