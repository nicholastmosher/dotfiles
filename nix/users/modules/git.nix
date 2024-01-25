{
  programs.git = {
    lfs.enable = true;
    aliases = {
      root = "rev-parse --show-toplevel";
    };
    difftastic = {
      enable = true;
    };
    extraConfig = {
      pager = {
        difftool = true;
      };
    };
  };
}

