{...}: {
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<esc>";
        action = "<CMD>noh<CR>";
      }
      {
        mode = "n";
        key = "}";
        action = "}zz";
      }
      {
        mode = "n";
        key = "{";
        action = "{zz";
      }
      {
        mode = "n";
        key = "<C-s>";
        action = "ZZ";
      }
      {
        mode = "n";
        key = "<C-x>";
        action = "ZQ";
      }
      {
        mode = "n";
        key = "D";
        action = "\"_D";
      }
      {
        mode = "n";
        key = "<leader>rw";
        action = ":%s/<C-r><C-w>//g<Left><Left>";
        options.desc = "Replace word under cursor";
      }
      {
        mode = "n";
        key = "<leader>al";
        action = ":lua vim.lsp.buf.format()<CR>";
        options.desc = "Format file with LSP";
      }

      {
        mode = ["n" "v"];
        key = "<leader>y";
        action = "\"+y";
        options.desc = "Yank to clipboard";
      }
      {
        mode = ["n" "v"];
        key = "<leader>p";
        action = "\"+p";
        options.desc = "Paste from clipboard";
      }
      {
        mode = "n";
        key = "<leader>ya";
        action = "ggVG\"+y";
        options.desc = "Yank entire buffer";
      }

      {
        action = "<cmd>Telescope find_files<CR>";
        key = "<leader>ff";
      }
      {
        action = "<cmd>Telescope live_grep<CR>";
        key = "<leader>fg";
      }
      {
        action = "<cmd>Telescope buffers<CR>";
        key = "<leader>fb";
      }
      {
        action = "<cmd>Telescope help_tags<CR>";
        key = "<leader>fh";
      }
      {
        action = "<cmd>NvimTreeToggle<CR>";
        key = "<leader>t";
      }
      {
        action = "<cmd>NvimTreeFocus<CR>";
        key = "<leader>r";
      }

      {
        mode = ["n"];
        key = "<leader>lm";
        action = "<cmd>VimtexContextMenu<CR>";
        options.desc = "Open Vimtex Context Menu";
      }
      {
        mode = ["n"];
        key = "<leader>lc";
        action = "<cmd>VimtexClean<CR>";
        options.desc = "Clean auxiliary files";
      }
      {
        mode = ["n"];
        key = "<leader>lC";
        action = "<cmd>VimtexClean!<CR>";
        options.desc = "Full Clean";
      }
      {
        mode = ["n"];
        key = "<leader>le";
        action = "<cmd>VimtexErrors<CR>";
        options.desc = "Show LaTeX compilation errors";
      }
      {
        mode = ["n"];
        key = "<leader>ls";
        action = "<cmd>VimtexStatus<CR>";
        options.desc = "Show Vimtex status";
      }
      {
        mode = ["n"];
        key = "<leader>li";
        action = "<cmd>VimtexInfo<CR>";
        options.desc = "Show Vimtex info";
      }
      {
        mode = ["n"];
        key = "<leader>lx";
        action = "<cmd>VimtexStop<CR>";
        options.desc = "Stop LaTeX compilation";
      }
      {
        mode = ["n"];
        key = "<leader>ll";
        action = "<cmd>VimtexCompile<CR>";
        options.desc = "Compile LaTeX document";
      }
      {
        mode = ["n"];
        key = "<leader>lv";
        action = "<cmd>VimtexView<CR>";
        options.desc = "View compiled PDF";
      }
      {
        mode = ["n"];
        key = "<leader>lt";
        action = "<cmd>VimtexTocToggle<CR>";
        options.desc = "Toggle table of contents";
      }
      {
        mode = ["n"];
        key = "<leader>lr";
        action = "<cmd>VimtexReload<CR>";
        options.desc = "Reload Vimtex";
      }
      {
        mode = ["n"];
        key = "<leader>lR";
        action = "<cmd>VimtexReloadState<CR>";
        options.desc = "Reload Vimtex State";
      }
    ];
  };
}
