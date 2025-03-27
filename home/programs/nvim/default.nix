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
      # nvim-tree-lua
      nvim-web-devicons
      render-markdown-nvim
      vim-visual-multi
      telescope-nvim
      markdown-preview-nvim
      lf-vim
      # yazi-nvim
      vimtex
      which-key-nvim

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
        ]))
    ];

    extraPackages = with pkgs; [
      ccls
      clang-tools
      gopls
      lua-language-server
      nixd
      pyright
      typescript-language-server
      vscode-langservers-extracted
      texlive.combined.scheme-full
    ];
  };
}
