{ config, lib, pkgs, ... }:

{
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.exa.enable = true;
  home.file.".gnupg/gpg.conf".source = ../../.gnupg/gpg.conf;
  home.file.".gnupg/gpg-agent.conf".source = ../../.gnupg/gpg-agent.conf;

  imports = [
    ./modules/alacritty.nix
    ./modules/direnv.nix
    ./modules/fzf.nix
    ./modules/git.nix
    ./modules/gnome.nix
    ./modules/kakoune.nix
    ./modules/packages.nix
    ./modules/starship.nix
    ./modules/tmux.nix
    ./modules/vscode.nix
    ./modules/zsh.nix
  ];

  home.packages = with pkgs; [
    vim
    xclip
    kakoune
    spotify
    alacritty
    signal-desktop
    gnome3.gnome-tweaks
  ];

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
  ];

  home.sessionVariables = {
    EDITOR = "kak";
  };
}
