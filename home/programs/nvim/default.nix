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
      cmp-nvim-lsp
      cmp-path
      lualine-nvim
      nvim-cmp
      nvim-lspconfig
      nvim-notify
      nvim-web-devicons
      render-markdown-nvim
      telescope-nvim
      lf-vim
      vimtex
      which-key-nvim
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
        p.tree-sitter-nix
        p.tree-sitter-markdown
        p.tree-sitter-latex
        p.tree-sitter-bash
      ]))
    ];

    extraPackages = with pkgs; [
      nixd
      alejandra
      texlive.combined.scheme-full
      nodePackages.prettier
      stylua
      tree-sitter
    ];
  };
}
