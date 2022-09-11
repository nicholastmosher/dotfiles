{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      shell.program = "${pkgs.zsh}/bin/zsh";
      shell.args = [ "-l" "-c" "${pkgs.tmux}/bin/tmux" ];
      colors = {
        primary = {
          background = "0x1f1f1f";
          foreground = "0xeaeaea";
        };
  
        cursor = {
          text = "0x000000";
          cursor = "0xffffff";
        };
  
        normal = {
          black = "0x000000";
          red = "0xf87373";
          green = "0x5efe7e";
          yellow = "0xffeb3d";
          blue = "0x03a9f4";
          magenta = "0xc397d8";
          cyan = "0xdfaf8f";
          white = "0xffffff";
        };
      };
    };
  };
}

