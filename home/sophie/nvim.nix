# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ self, config, pkgs, lib, ... }: {
  home.packages = with pkgs; [
    # language servers for nvim
    # TODO: migrate to nixvim
    git
    gcc
    gopls
    pyright
    eslint
    eslint_d
    tree-sitter
    typescript-language-server
    go
    libxml2
    shfmt
    jq
    stylua
    yamlfmt
    shellcheck
    black
    python313Packages.cssbeautifier
    lua-language-server
    bash-language-server
    vscode-langservers-extracted
    ltex-ls-plus
    cmake
    cmake-language-server
    perl540Packages.PerlTidy
    html-tidy
    python3
    nixfmt-classic
  ];
  home.sessionVariables = { MANPAGER = "nvim +Man!"; };
  xdg.configFile.nvim.source = pkgs.fetchgit {
    url = "https://github.com/sophuric/nvim.git";
    rev = "b74d2c0ce134aab26e8942b275139cd7ddc5efb3";
    sha256 = "sha256-BtlqmGeOim2fCeOKBzTO+Ui+p04R52uf9SNbrVCQj1A=";
  };
}
