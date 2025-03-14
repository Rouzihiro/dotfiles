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
        key = "<leader>s";
        action = ":w<CR>";
        options.desc = "Save file";
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
        options.desc = "save & exit";
      }
      {
        mode = "n";
        key = "<C-x>";
        action = "ZQ";
        options.desc = "exit without saving";
      }
      {
        mode = "n";
        key = "D";
        action = "\"_D";
        options.desc = "delete line from here";
      }
      {
        mode = "n";
        key = "<leader>rr";
        action = ":reg<CR>";
        options.desc = "show reg";
      }
      {
        mode = ["n" "v"];
        key = "<leader>yy";
        action = ''"ay'';
        options.desc = "yank into reg: a";
      }
      {
        mode = ["n" "v"];
        key = "<leader>yb";
        action = ''"by'';
        options.desc = "yank into reg: b";
      }
      {
        mode = ["n" "v"];
        key = "<leader>pp";
        action = ''"ap'';
        options.desc = "paste from reg: a";
      }
      {
        mode = ["n" "v"];
        key = "<leader>pb";
        action = ''"bp'';
        options.desc = "paste from reg: b";
      }
      {
        mode = ["n" "v"];
        key = "<leader>yx";
        action = ''"Ay'';
        options.desc = "Append to register a";
      }
      {
        mode = ["n" "v"];
        key = "<leader>yb";
        action = ''"By'';
        options.desc = "Append to register b";
      }
      {
        mode = ["n" "v"];
        key = "<leader>rw";
        action = ":%s/<C-r><C-w>//g<Left><Left>";
        options.desc = "Replace word under cursor";
      }
      {
        mode = "n";
        key = "<leader>al";
        action = ":lua vim.lsp.buf.format()<CR>";
        options.desc = "alejandra";
      }

      {
        mode = ["n" "v"];
        key = "<leader>yc";
        action = "\"+y";
        options.desc = "Yank to clipboard";
      }
      {
        mode = ["n" "v"];
        key = "<leader>pc";
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
