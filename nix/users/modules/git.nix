{
  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
  };
  programs.git = {
    lfs.enable = true;
    extraConfig = {
      safe.directory = "/home/nmosher/.dotfiles";
    };

    delta = {
      enable = true;
      options = {
        side-by-side = true;
        plus-style = ''syntax "#003700"'';
      };
    };
  };
}

