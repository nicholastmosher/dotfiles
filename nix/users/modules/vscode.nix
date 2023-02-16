{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    php80
  ];

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      jnoortheen.nix-ide
      bungcip.better-toml
      ms-azuretools.vscode-docker
      ms-vscode-remote.remote-ssh
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
        key = "ctrl+t";
        command = "workbench.action.navigateBack";
      }
      {
        key = "ctrl+shift+]";
        command = "workbench.files.action.showActiveFileInExplorer";
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
            "*.documentation" = "#68DF6C";
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
      "rust-analyzer.completion.privateEditable.enable" = true;
      "rust-analyzer.completion.snippets.custom" = {
        "Arc::new" = {
          postfix = "arc";
          body = "Arc::new(\${receiver})";
          requires = "std::sync::Arc";
          description = "Put the expression into an Arc";
          scope = "expr";
        };
        "Rc::new" = {
          postfix = "rc";
          body = "Rc::new(\${receiver})";
          requires = "std::rc::Rc";
          description = "Put the expression into an Rc";
          scope = "expr";
        };
        "Box::pin" = {
          postfix = "pinbox";
          body = "Box::pin(\${receiver})";
          requires = "std::box::Boxed";
          description = "Put the expression into a Pinned Box";
          scope = "expr";
        };
        "Ok" = {
          postfix = "ok";
          body = "Ok(\${receiver})";
          description = "Put the expression into a Result::Ok";
          scope = "expr";
        };
        "Err" = {
          postfix = "err";
          body = "Err(\${receiver})";
          description = "Put the expression into a Result::Err";
          scope = "expr";
        };
        "Some" = {
          postfix = "some";
          body = "Some(\${receiver})";
          description = "Put the expression into a Option::Some";
          scope = "expr";
        };
        "dotenv" = {
          prefix = "dotenv";
          scope = "expr";
          description = "Load environment variables";
          body = "let _ = dotenv::dotenv();";
        };
        "tracing_subscriber" = {
          prefix = [
            "tracing_subscriber::Registry::default"
            "Registry::default"
          ];
          description = "Initialize tracing subscriber";
          scope = "expr";
          requires = "tracing_subscriber::Registry";
          body = [
            "Registry::default()"
            "    .with(tracing_subscriber::fmt::layer())"
            "    .with(tracing_subscriber::EnvFilter::from_default_env())"
            "    .try_init()?;"
            "    tracing::info!(\"Initialized tracing!\");"
          ];
        };
        "Cli" = {
          prefix = "Cli";
          scope = "item";
          requires = [
            "clap::Parser"
            "clap::Args"
            "clap::Subcommand"
          ];
          body = [
            "#[derive(Debug, Parser)]"
            "pub struct Cli {"
            "    /// Global args"
            "    #[clap(flatten)]"
            "    pub args: Args,"
            "    /// Subcommands"
            "    #[clap(subcommand)]"
            "    pub cmd: Cmd,"
            "}"
            ""
            "#[derive(Debug, Args)]"
            "pub struct Args {}"
            ""
            "#[derive(Debug, Subcommand)]"
            "pub enum Cmd {"
            "    Help,"
            "}"
          ];
        };
        "tokio::task::spawn" = {
          prefix = [
            "tokio::task::spawn"
            "tokio::spawn"
            "spawn"
          ];
          scope = "expr";
          body = [
            "tokio::task::spawn(async move {"
            "    todo!()"
            "});"
          ];
        };
      };
      "update.mode" = "none";
      "vim.useSystemClipboard" = true;
      "vim.handleKeys" = {
        "<C-w>" = false;
      };
      "workbench.tree.indent" = 20;
      "workbench.colorTheme" = "Ayu Mirage Bordered";
      "terminal.integrated.defaultProfile.linux" = "tmux";
    };
  };
}

