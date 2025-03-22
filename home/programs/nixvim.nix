{
  pkgs,
  inputs,
  ...
}: let
  variables = import ../../hosts/modules/variables.nix;
  theme = variables.theme;
in {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./nixvim-keymaps.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;
    colorschemes.${theme} = {
      autoLoad = true;
      enable = true;
      settings = {
        flavour = "mocha";
        default_integrations = true;
        integrations = {
          cmp = true;
          gitsigns = true;
          mini = {
            enabled = true;
          };
          treesitter = true;
        };
        styles = {
          booleans = [
            "bold"
            "italic"
          ];
          conitionals = [
            "bold"
          ];
        };
        term_colors = true;
        transparent_background = true;
      };
    };
    colorscheme = theme;
    opts = {
      number = true;
      relativenumber = true;
      smartindent = true;
      shiftwidth = 4;
      swapfile = false;
      ignorecase = true;
      smartcase = true;
      incsearch = true;
    };

    globals.mapleader = " ";
    clipboard.register = "unnamedplus";

    plugins = {
      aerial = {
        enable = true;
        settings = {
          attach_mode = "global";
          backends = ["treesitter" "lsp" "markdown" "man"];
          disable_max_lines = 5000;
          highlight_on_hover = true;
          ignore = {
            filetypes = ["gomod"];
          };
        };
      };
      render-markdown = {
        enable = true;
        settings = {
          style = "dark";
          width = 80;
        };
      };
      visual-multi.enable = true;
      illuminate.enable = true;
      web-devicons.enable = true;
      lualine.enable = true;
      which-key.enable = true;
      cmp-path.enable = true;
      conform-nvim.enable = true;
      nvim-tree = {
        enable = true;
        autoReloadOnWrite = true;
        openOnSetup = true;
        extraOptions = {view = {side = "right";};};
      };
      vim-be-good.enable = true;
      bullets = {
        enable = true;
        settings = {
          enable_in_empty_buffers = 0;
          enabled_file_types = [
            "markdown"
            "text"
            "gitcommit"
            "scratch"
          ];
          nested_checkboxes = 0;
        };
      };

      vimtex = {
        enable = true;
        settings = {
          lualine = false;
          latexmk = true;
        };
      };

      treesitter = {
        enable = true;
        settings = {
          defaults = {
            file_ignore_patterns = [
              "^.git/"
              "^.mypy_cache/"
              "^__pycache__/"
              "^output/"
              "^data/"
              "%.ipynb"
            ];
            layout_config = {prompt_position = "top";};
            mappings = {
              i = {
                "<A-j>" = {
                  __raw = "require('telescope.actions').move_selection_next";
                };
                "<A-k>" = {
                  __raw = "require('telescope.actions').move_selection_previous";
                };
              };
            };
            selection_caret = "> ";
            set_env = {COLORTERM = "truecolor";};
            sorting_strategy = "ascending";
          };
        };
      };

      cmp = {
        enable = true;
        autoEnableSources = false;
        settings = {
          mapping = {
            __raw = ''
              cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
              })
            '';
          };
          snippet = {
            expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          };
          sources = [
            {name = "nvim_lsp";}
            {name = "luasnip";}
            {name = "path";}
            {name = "buffer";}
          ];
        };
      };

      cmp-ai.enable = true;
      cmp-buffer.enable = true;
      cmp-nvim-lsp.enable = true;
      #direnv.enable = true;
      noice.enable = true;
      nix.enable = true;
      #nix-develop.enable = true;
      notify = {
        enable = true;
        settings = {
          render = "minimal";
          stages = "static";
        };
      };

      bufferline = {
        enable = true;
        settings.options.alwaysShowBufferline = true;
      };

      lsp = {
        enable = true;
        servers = {
          nixd = {
            enable = true;
            settings = {
              formatting = {
                command = ["alejandra"];
              };
            };
          };
          #html.enable = true;
          #java_language_server.enable = true;
          #jsonls.enable = true;
          #lua_ls.enable = true;
          #ts_ls.enable = true;
          #ccls.enable = true;
        };
        keymaps.diagnostic = {
          "<leader>j" = "goto_next";
          "<leader>k" = "goto_prev";
        };
        keymaps.lspBuf = {
          K = "hover";
          gD = "references";
          gd = "definition";
          gi = "implementation";
          gt = "type_definition";
        };
      };

      comment.enable = true;
      indent-blankline.enable = true;
      telescope.enable = true;
    };
  };
}
