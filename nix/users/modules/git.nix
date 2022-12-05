{
  programs.gh.enable = true;
  programs.git = {
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

