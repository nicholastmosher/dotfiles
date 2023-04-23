{
  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
  };
  programs.git = {
    lfs.enable = true;
    aliases = {
      root = "rev-parse --show-toplevel";
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

