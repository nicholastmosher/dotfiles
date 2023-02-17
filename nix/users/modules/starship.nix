{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      aws.disabled = true;
      nix_shell.symbol = "❄️ ";
    };
  };
}
