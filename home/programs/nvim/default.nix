{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = builtins.readFile ./init.lua;

    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      alpha-nvim
      cmp-nvim-lsp
      cmp-path
      conform-nvim
      indent-blankline-nvim
      lualine-nvim
      luasnip
      friendly-snippets
      cmp_luasnip
      nix-develop-nvim
      noice-nvim
      nvim-cmp
      nvim-lspconfig
      nvim-notify
      nvim-web-devicons
      render-markdown-nvim
      vim-visual-multi
      telescope-nvim
      markdown-preview-nvim
      lf-vim
      vimtex
      which-key-nvim
      mini-nvim

      (nvim-treesitter.withPlugins (p:
        with p; [
          tree-sitter-bash
          tree-sitter-c
          tree-sitter-cpp
          tree-sitter-dockerfile
          tree-sitter-go
          tree-sitter-gomod
          tree-sitter-html
          tree-sitter-json
          tree-sitter-lua
          tree-sitter-nix
          tree-sitter-php
          tree-sitter-python
          tree-sitter-todotxt
          tree-sitter-yaml
          tree-sitter-query
          tree-sitter-regex
        ]))
    ];

    extraPackages = with pkgs; [
      ccls
      clang-tools
      go
      lua-language-server
      nixd
      pyright
      typescript-language-server
      vscode-langservers-extracted
      texlive.combined.scheme-full
      python3Packages.black
      python3Packages.isort
      nodePackages.prettier
      rustfmt
      stylua
    ];
  };
}
