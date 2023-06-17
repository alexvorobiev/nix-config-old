{ pkgs }:

with pkgs;
[

  # system
  gnome3.adwaita-icon-theme
  aspell
  aspellDicts.en

  curl

  hicolor-icon-theme
  htop
  iftop
  iotop
  iperf
  inetutils

  gnugrep
  gnused
  
  mc
  #(mkvtoolnix.override { withGUI = false; })
  mutagen
  ncdu
  # to get sha256, etc.
  #nix-prefetch-scripts
  #nix-bash-completions
  #nixdu
  nix-tree
  nixpkgs-fmt
  rnix-lsp

  #expect
  openssh
  #pdf-tools-server
  procps
  pstree
  #python3Packages.powerline
  ripgrep
  rsync

  #s
  silver-searcher

  #  (texlive.combine {
  #    inherit (texlive) scheme-medium envlab;
  #  })

  #tmux
  unzip
  wget
  # zotero indexing
  #xpdf
  #youtube-dl
  #veracrypt
  #z

  # fonts
  emacs-all-the-icons-fonts
  font-awesome
  font-awesome_5
  hasklig
  inconsolata
  source-code-pro
  source-sans-pro
  source-serif-pro
  # mail
  #isync
  #mu
  #msmtp
  #davmail

  # org-roam dependencies
  sqlite
  graphviz

  # org-web-tools
  #pandoc

  #emacsCust

]
