{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      matklad.rust-analyzer
    ];
    keybindings = [
      {
        key = "ctrl+]";
        command = "editor.action.goToDeclaration";
      }
    ];
    userSettings = {
      # Fixes capslock as escape
      "keyboard.dispatch" = "keyCode";
      "workbench.colorTheme" = "Darcula (IntelliJ)";
      "nix.enableLanguageServer" = true;
      "dance.modes" = {
        "normal" = {
          "cursorStyle" = "block";
          "selectionBehavior" = "character";
        };
      };
    };
  };
}

