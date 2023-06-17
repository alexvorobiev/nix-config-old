self: super: {
  emacsCust = hostName:
    self.emacsWithPackagesFromUsePackage {

      alwaysEnsure = true;
      alwaysTangle = true;

      package = (self.emacsUnstable.override {
        withXwidgets = true;
      });
        #.overrideAttrs(oa: {
	#        name = "${oa.name}-xwidgets";
	#      }));

      config =
        let
          tangledOrgConfig = self.runCommand "tangled-emacs-config" { } ''
            cp ${/home/alex/.config/emacs/config.org} config.org
            cp ${/home/alex/.config/emacs/nixos.org} nixos.org

            ${self.emacsNativeComp}/bin/emacs --batch -Q config.org -f org-babel-tangle
            ${self.emacsNativeComp}/bin/emacs --batch -Q nixos.org  -f org-babel-tangle
            cat nixos.el >> config.el
            cp config.el $out
          '';
          # eyeliner = (callPackage pkgs/eyeliner {});

        in
        builtins.readFile tangledOrgConfig;

      extraEmacsPackages = epkgs: [
        epkgs.org
        epkgs.org-contrib
        epkgs.font-lock-plus

        #        (epkgs.melpaBuild {
        #          pname = "eyeliner";
        #          version = "0.1";
        #
        #          src = fetchgit {
        #            url = "https://github.com/dustinlacewell/eyeliner.git";
        #            rev = "d0c68c401d7e95f3149b3afa90634571378cffde";
        #            sha256 = "03p9j70lrx48klqf6d3ysf6wyhw0ras8p4dh71zwq5rp1k0pl365";
        #          };
        #
        #          recipe = pkgs.writeText "recipe" "(eyeliner :repo \"dustinlacewell/eyeliner\" :fetcher github)";
        #          # (font-lock+ :fetcher github :repo \"\")";
        #
        #          packageRequires = with epkgs; [ spaceline magit all-the-icons dash ];
        #
        #          meta = {
        #            homepage = "https://github.com/dustinlacewell/eyeliner";
        #            license = pkgs.lib.licenses.gpl2Plus;
        #          };
        #        })
      ];
    };
}
