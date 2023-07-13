{
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
        plus-emph-style = ''syntax "#008700"'';
        features = "decorations";
        decorations = {
          file-style = "bold yellow ul";
          file-decoration-style = "none";
          hunk-header-style = "omit";
        };
      };
    };
  };
}

