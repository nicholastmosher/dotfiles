{
  home.sessionVariables = {
    EDITOR = "kak";
  };

  programs.kakoune = {
    enable = true;
    config = {
      colorScheme = "tomorrow-night";
      numberLines.enable = true;
      tabStop = 4;
      keyMappings = [
        {
          key = "<tab>";
          mode = "insert";
          effect = "    ";
          docstring = "Use spaces instead of tabs";
        }
      ];
    };
  };
}
