# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
args@{ self, config, lib, pkgs, ... }: {
  catppuccin =
    (lib.attrsets.genAttrs [ "bat" "fzf" "zsh-syntax-highlighting" "btop" ]
      (x: { enable = true; }));

  home = {
    packages = with pkgs; [
      # command line tools
      file
      zip
      unzip
      less
      killall
      btop
      pv
    ];
    shell.enableShellIntegration = true;
    shellAliases = {
      "nixos-update" = "sudo nixos-rebuild switch --flake /etc/nixos --impure";
      cd = "z";
      exa = "eza";
      ls = "eza";
      lr = "eza --sort modified";
      tree = "ls --tree";
      less = "less --RAW-CONTROL-CHARS";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      diff = "diff --color=auto";
      cp = "cp -i --one-file-system";
      rm = "rm -i --one-file-system";
      mv = "mv -i";
      sudo = "sudo ";
      gdiff = "git diff";
      glog = "git log";
      gadd = "git add";
      ginfo = "git info";
      grm = "git rm --cached";
      gstatus = "git status";
      commit = "git commit";
      push = "git push";
      pull = "git pull";
      clone = "git clone";
      ca = "git commit";
    };
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
      };
      syntaxHighlighting = {
        enable = true;
        highlighters = [ "main" "brackets" ];
      };
      initContent = ''
        setopt HIST_FCNTL_LOCK RM_STAR_WAIT AUTO_PUSHD CHASE_DOTS CHASE_LINKS PUSHD_IGNORE_DUPS PUSHD_SILENT AUTO_LIST GLOB_DOTS
        bindkey '\C-h' backward-kill-word
      '';
      history = {
        size = 10000;
        save = 10000;
        ignoreDups = true;
        share = true;
        extended = true;
      };
      autocd = true;
    };

    dircolors = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        FILE = "38;5;15";
        BLOCK = "38;5;13";
        CHAR = "38;5;11";
        LINK = "38;5;14";
        PIPE = "38;5;11";
        SOCK = "38;5;11";
        DIR = "38;5;12";
        EXEC = "38;5;10";
        ORPHAN = "38;5;1";
        ".jar" = "38;5;208";
        ".lua" = "38;5;126";
        ".py" = "38;5;184";
      } // (lib.attrsets.genAttrs [
        ".z64"
        ".n64"
        ".nds"
        ".cia"
        ".nes"
        ".gb"
        ".gbc"
        ".gba"
        ".sgm"
        ".sav"
      ] (x: "38;5;48"));
    };
  };
  home.sessionVariables.EXA_COLORS =
    "ur=38;5;11:uw=38;5;9:ux=38;5;10:ue=38;5;10:gr=38;5;11:gw=38;5;9:gx=38;5;10:tr=38;5;11:tw=38;5;9:tx=38;5;10:su=38;5;13:sf=38;5;13:xa=38;5;13:sn=38;5;14:sb=38;5;6:df=38;5;11:ds=38;5;11:uu=38;5;14:un=38;5;15:gu=38;5;10:gn=38;5;15:lc=38;5;9:lm=38;5;13:ga=38;5;10:gm=38;5;14:gd=38;5;9:gv=38;5;11:gt=38;5;13:xx=38;5;8:da=38;5;14:in=38;5;13:bl=38;5;13:hd=38;5;15:lp=38;5;14:cc=48;5;15;38;5;0";
  programs = {

    zoxide.enable = true;
    zoxide.enableZshIntegration = true;

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    eza = {
      enable = true;
      colors = "auto";
      enableZshIntegration = true;
      icons = "auto";
      extraOptions = [ "--header" "--group" "--binary" "--sort=Name" ];
    };

    ripgrep.enable = true;

    bat = {
      config = {
        pager = "less --RAW-CONTROL-CHARS --quit-if-one-screen --quit-on-intr";
        decorations = "never";
      };
      enable = true;
    };

    git = {
      enable = true;
      lfs.enable = true;
      aliases = {
        sub = "submodule";
        subc = "submodule update --init --recursive";
        unstage = "restore --staged";
        r = "remote";
      };
      userEmail = "48314599+sophuric@users.noreply.github.com";
      userName = "sophur";
      signing = {
        key = "EAB0A643ABD82124552040FE39F3751CDD35BB5F";
        signByDefault = true;
      };
      extraConfig = {
        init.defaultBranch = "main";
        color.ui = "auto";
        format.pretty =
          "format:Commit %C(green)%H%C(auto)%(decorate)%C(default) %C(yellow)(%C(green)%G?%C(yellow))%nAuthor: %an %C(default)%C(dim)<%C(nodim)%C(default)%ae%C(default)%C(dim)> - %C(nodim)%ad%nCommit: %cn %C(default)<%ce%C(default)> - %cd%n%n%C(default)%C(dim)> %C(nodim)%C(magenta)%C(ul)%s%n%n%b%n%C(dim)---%C(nodim)%C(default)";
        url = { "https://github.com/" = { insteadOf = [ "gh:" "github:" ]; }; };
      };
    };

    ssh = {
      enable = true;
      addKeysToAgent = "yes";
      matchBlocks = {
        "*" = { serverAliveInterval = 240; };
        "github.com" = {
          identityFile = "~/.ssh/online_ed25519";
          user = "git";
        };
        "gist.github.com" = {
          identityFile = "~/.ssh/online_ed25519";
          user = "git";
        };
        "gitlab.com" = {
          identityFile = "~/.ssh/online_ed25519";
          user = "git";
        };
      };
    };
  };
}
