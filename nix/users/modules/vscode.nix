{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    php80
  ];

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      matklad.rust-analyzer
    ];
    keybindings = [
      {
        key = "ctrl+b";
        command = "";
      }
      {
        key = "ctrl+b ctrl+l";
        when = "terminalFocus";
        command = "workbench.action.terminal.clear";
      }
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
      "dance.modes" = {
        "normal" = {
          "cursorStyle" = "block";
          "selectionBehavior" = "character";
        };
      };
      "editor.formatOnSave" = true;
      "editor.rulers" = [100];
      "editor.semanticTokenColorCustomizations" = {
        "[Ayu Mirage Bordered]" = {
          enabled = true;
          rules = {
            typeParameter = "#00ff9d";
          };
        };
      };
      "files.autoSave" = "onFocusChange";
      # Fixes capslock as escape
      "keyboard.dispatch" = "keyCode";
      "nix.enableLanguageServer" = true;
      "php.validate.executablePath" = "${pkgs.php80}/bin/php";
      "rust-analyzer.checkOnSave.command" = "clippy";
      "rust-analyzer.assist.allowMergingIntoGlobImports" = false;
      "update.mode" = "none";
      "vim.vimrc.enable" = true;
      "vim.vimrc.path" = "${config.home.homeDirectory}/.ideavimrc";
      "workbench.colorTheme" = "Ayu Mirage Bordered";
    };
  };
}

