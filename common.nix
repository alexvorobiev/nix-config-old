{ config, pkgs, emacsOverlay, ... }:

rec {

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      doCheckByDefault = false;
    };

    overlays =
      let path = ./overlays; in
      with builtins;
      (map (n: import (path + ("/" + n)))
        (filter
          (n: match ".*\\.nix" n != null ||
          pathExists (path + ("/" + n + "/default.nix")))
          (attrNames (readDir path))))
      ++ [ emacsOverlay.overlay ];
  };

  home.packages = import ./packages.nix { inherit pkgs; };

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    theme = {
      package = pkgs.numix-solarized-gtk-theme;
      name = "NumixSolarizedDarkBlue";
    };
  };

  xresources = {
    extraConfig = (builtins.readFile (
      pkgs.fetchFromGitHub {
        owner = "DanManN";
        repo  = "base16-xresources";
        rev   = "52f4f75bbb7d1ec30b14e3bca9dc30483b255de1";
        sha256 = "0qqcnhlca100a77j3m9jki8y2cnkfq1h5y6gcw4160hjyam7f7c6";
      } + "/xresources/base16-solarized-dark-256.Xresources"
    ) + ''
      st.font:     Source Code Pro:pixelsize=17:antialias=true:autohint=true;
      st.termname: xterm-256color
    '');
  };

  programs = {
    direnv = {
      enable = true;
      # https://github.com/nix-community/nix-direnv
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    fzf = {
      enable = true;

      defaultOptions = [ "--height 40%" "--border" ];
      # ctrl-t
      fileWidgetOptions = [ "--preview 'head {}'" ];
      # alt-c
      changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
      # ctrl-r
      historyWidgetOptions = [ "--sort" "--exact" ];

      enableZshIntegration = true;
    };

    git = {
      enable = true;

      # Configuration goes to xdg (~/.config/git)
      userName = "Alex Vorobiev";
      userEmail = "alexander.vorobiev@gmail.com";

      # Syntax highlighting for diff
      delta.enable = true;

      extraConfig = {
        branch.autosetupmerge = true;
        github.user = "alexvorobiev";
        pull.rebase = true;
        rebase.autosquash = true;
        rerere.enabled = true;

        push = {
          default = "tracking";
          recurseSubmodules = "check";
        };
      };
    };

    gpg = {
      enable = true;
      settings = {
        personal-digest-preferences = "SHA256";
        cert-digest-algo = "SHA256";
        default-preference-list = "SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed";
      };
    };

    man.enable = true;

    tmux = {
      enable = true;
      terminal = "screen-256color";
      historyLimit = 10000;
      newSession = true;

      # /run doesn't exist in wsl
      #secureSocket = false;

      extraConfig = ''
        # don't use a login shell
        set-option -g default-command ${pkgs.zsh}/bin/zsh

        ## COLORSCHEME: gruvbox dark
        ## https://github.com/egel/tmux-gruvbox
        set-option -g status "on"

        # default statusbar color
        set-option -g status-style bg=colour237,fg=colour223 # bg=bg1, fg=fg1

        # default window title colors
        set-window-option -g window-status-style bg=colour214,fg=colour237 # bg=yellow, fg=bg1

        # default window with an activity alert
        set-window-option -g window-status-activity-style bg=colour237,fg=colour248 # bg=bg1, fg=fg3

        # active window title colors
        set-window-option -g window-status-current-style bg=red,fg=colour237 # fg=bg1

        # pane border
        set-option -g pane-active-border-style fg=colour250 #fg2
        set-option -g pane-border-style fg=colour237 #bg1

        # message infos
        set-option -g message-style bg=colour239,fg=colour223 # bg=bg2, fg=fg1

        # writing commands inactive
        set-option -g message-command-style bg=colour239,fg=colour223 # bg=fg3, fg=bg1

        # pane number display
        set-option -g display-panes-active-colour colour250 #fg2
        set-option -g display-panes-colour colour237 #bg1

        # clock
        set-window-option -g clock-mode-colour colour109 #blue

        # bell
        set-window-option -g window-status-bell-style bg=colour167,fg=colour235 # bg=red, fg=bg

        ## Theme settings mixed with colors (unfortunately, but there is no cleaner way)
        set-option -g status-justify "left"
        set-option -g status-left-style none
        set-option -g status-left-length "80"
        set-option -g status-right-style none
        set-option -g status-right-length "80"
        set-window-option -g window-status-separator ""

        set-option -g status-left "#[fg=colour248, bg=colour241] #S #[fg=colour241, bg=colour237, nobold, noitalics, nounderscore]"
        set-option -g status-right "#[fg=colour239, bg=colour237, nobold, nounderscore, noitalics]#[fg=colour246,bg=colour239] %Y-%m-%d  %H:%M #[fg=colour248, bg=colour239, nobold, noitalics, nounderscore]#[fg=colour237, bg=colour248] #h "

        set-window-option -g window-status-current-format "#[fg=colour237, bg=colour214, nobold, noitalics, nounderscore]#[fg=colour239, bg=colour214] #I #[fg=colour239, bg=colour214, bold] #W #[fg=colour214, bg=colour237, nobold, noitalics, nounderscore]"
        set-window-option -g window-status-format "#[fg=colour237,bg=colour239,noitalics]#[fg=colour223,bg=colour239] #I #[fg=colour223, bg=colour239] #W #[fg=colour239, bg=colour237, noitalics]"

      '';
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;

      # This will let termite track the current working directory.
      # enableVteIntegration = true;

      autocd = true;
      defaultKeymap = "emacs";

      # Save timestamp into the history file.
      history.extended = true;

      prezto = {
        enable = true;

        prompt = {
          theme = "powerlevel10k";
        };
      };

      plugins = [
        {
          name = "fast-syntax-highlighting";
          src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
        }
      ];

      initExtra = ''
        # https://github.com/akermu/emacs-libvterm
        vterm_printf(){
            if [ -n "$TMUX" ]; then
               # Tell tmux to pass the escape sequences through
               # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
               printf "\ePtmux;\e\e]%s\007\e\\" "$1"
            elif [ "''${TERM%%-*}" = "screen" ]; then
               # GNU screen (screen, screen-256color, screen-256color-bce)
               printf "\eP\e]%s\007\e\\" "$1"
            else
               printf "\e]%s\e\\" "$1"
            fi
        }

        if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
            alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'
        fi

        autoload -U add-zsh-hook
        add-zsh-hook -Uz chpwd (){ print -Pn "\e]2;%m:%2~\a" }

        vterm_prompt_end() {
            vterm_printf "51;A$(whoami)@$(hostname):$(pwd)";
        }
        setopt PROMPT_SUBST
        PROMPT=$PROMPT'%{$(vterm_prompt_end)%}'
      '';
    };

  };
}
