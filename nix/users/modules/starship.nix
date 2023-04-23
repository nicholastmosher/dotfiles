{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      aws.disabled = true;
      nix_shell.symbol = "❄️ ";
      git_status.disabled = true;
      directory.truncate_to_repo = false;
      directory.truncation_length = 10;
    };
  };
}
