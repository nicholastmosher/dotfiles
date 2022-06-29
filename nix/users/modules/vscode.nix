{ pkgs, config, ... }:
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      matklad.rust-analyzer
    ];
    keybindings = [
      {
        key = "ctrl+]";
        command = "editor.action.goToDeclaration";
      }
      {
        key = "ctrl+[";
        command = "editor.action.goToTypeDefinition";
      }
      {
        key = "ctrl+'";
        command = "workbench.action.terminal.toggleTerminal";
      }
      {
        key = "ctrl+h";
        command = "workbench.action.navigateLeft";
      }
      {
        key = "ctrl+l";
        command = "workbench.action.navigateRight";
      }
      {
        key = "ctrl+j";
        command = "";
      }
      {
        key = "ctrl+k";
        command = "";
      }
    ];
    userSettings = {
      # Fixes capslock as escape
      "keyboard.dispatch" = "keyCode";
      "workbench.colorTheme" = "Ayu Mirage Bordered";
      "editor.semanticTokenColorCustomizations" = {
        "[Ayu Mirage Bordered]" = {
          enabled = true;
          rules = {
            typeParameter = "#00ff9d";
          };
        };
      };
      "vim.vimrc.enable" = true;
      "vim.vimrc.path" = "${config.home.homeDirectory}/.ideavimrc";
      "files.autoSave" = "onFocusChange";
      "rust-analyzer.checkOnSave.command" = "clippy";
      "editor.formatOnSave" = true;
      "editor.rulers" = [100];
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

