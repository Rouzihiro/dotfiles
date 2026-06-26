-- mandalorian.lua
-- Custom Neovim colorscheme — The Mandalorian
-- Beskar steel, desert dust, burnt iron, the void between stars.
-- Drop into ~/.config/nvim/colors/mandalorian.lua

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "mandalorian"
vim.o.termguicolors = true
vim.o.background = "dark"

-- ─── Palette ──────────────────────────────────────────────────────────────────
local c = {
  bg          = "#080808",  -- the void
  bg_subtle   = "#141210",  -- barely lifted dark
  bg_muted    = "#504036",  -- taupe — cracked desert earth
  bg_sel      = "#2A2018",  -- dark warm mid for selections
  fg          = "#DCCAB3",  -- pale oak — parchment
  fg_dim      = "#998272",  -- dusty taupe — aged leather
  fg_faint    = "#5F5B56",  -- charcoal — receding steel
  silver      = "#B3B3AC",  -- silver — polished beskar
  grey_olive  = "#969992",  -- grey olive — muted beskar
  slate       = "#6C7D87",  -- slate grey — cool beskar sheen
  copper      = "#8B705B",  -- faded copper — worn armor plate
  iron        = "#7C3B1C",  -- saddle brown — burnt iron / rust blood
  taupe       = "#504036",  -- same as bg_muted, explicit alias
  none        = "NONE",
}

local hi = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ─── Editor UI ────────────────────────────────────────────────────────────────
hi("Normal",           { fg = c.fg,        bg = c.bg })
hi("NormalFloat",      { fg = c.fg,        bg = c.bg_subtle })
hi("NormalNC",         { fg = c.fg_dim,    bg = c.bg })
hi("SignColumn",       { fg = c.fg_faint,  bg = c.bg })
hi("ColorColumn",      {                   bg = c.bg_subtle })
hi("CursorLine",       {                   bg = c.bg_subtle })
hi("CursorLineNr",     { fg = c.fg,        bg = c.bg_subtle, bold = true })
hi("CursorColumn",     {                   bg = c.bg_subtle })
hi("LineNr",           { fg = c.fg_faint })
hi("Cursor",           { fg = c.bg,        bg = c.fg })
hi("TermCursor",       { fg = c.bg,        bg = c.fg })
hi("Visual",           { fg = c.fg,        bg = c.bg_muted })
hi("VisualNOS",        { fg = c.fg,        bg = c.bg_muted })
hi("IncSearch",        { fg = c.bg,        bg = c.fg,        bold = true })
hi("Search",           { fg = c.bg,        bg = c.copper })
hi("Substitute",       { fg = c.bg,        bg = c.iron })
hi("MatchParen",       { fg = c.fg,        bg = c.none,      bold = true, underline = true })
hi("StatusLine",       { fg = c.fg_dim,    bg = c.bg_muted })
hi("StatusLineNC",     { fg = c.fg_faint,  bg = c.bg_subtle })
hi("WinSeparator",     { fg = c.bg_muted })
hi("VertSplit",        { fg = c.bg_muted })
hi("TabLine",          { fg = c.fg_faint,  bg = c.bg_subtle })
hi("TabLineFill",      {                   bg = c.bg })
hi("TabLineSel",       { fg = c.fg,        bg = c.bg_muted,  bold = true })
hi("Pmenu",            { fg = c.fg,        bg = c.bg_subtle })
hi("PmenuSel",         { fg = c.bg,        bg = c.slate,     bold = true })
hi("PmenuSbar",        {                   bg = c.bg_muted })
hi("PmenuThumb",       {                   bg = c.fg_faint })
hi("WildMenu",         { fg = c.bg,        bg = c.fg })
hi("Folded",           { fg = c.fg_dim,    bg = c.bg_subtle, italic = true })
hi("FoldColumn",       { fg = c.fg_faint,  bg = c.bg })
hi("EndOfBuffer",      { fg = c.bg_subtle })
hi("NonText",          { fg = c.bg_muted })
hi("SpecialKey",       { fg = c.bg_muted })
hi("Whitespace",       { fg = c.bg_muted })
hi("Directory",        { fg = c.slate })
hi("Title",            { fg = c.fg,        bold = true })
hi("Question",         { fg = c.slate })
hi("MoreMsg",          { fg = c.slate })
hi("ModeMsg",          { fg = c.fg,        bold = true })
hi("MsgArea",          { fg = c.fg_dim })
hi("ErrorMsg",         { fg = c.iron,      bold = true })
hi("WarningMsg",       { fg = c.copper })
hi("QuickFixLine",     { fg = c.bg,        bg = c.slate })
hi("SpellBad",         { undercurl = true, sp = c.iron })
hi("SpellCap",         { undercurl = true, sp = c.slate })
hi("SpellLocal",       { undercurl = true, sp = c.copper })
hi("SpellRare",        { undercurl = true, sp = c.fg_dim })

-- ─── Syntax ───────────────────────────────────────────────────────────────────
hi("Comment",          { fg = c.fg_faint,  italic = true })
hi("Constant",         { fg = c.silver })
hi("String",           { fg = c.fg })         -- pale oak — parchment text
hi("Character",        { fg = c.fg })
hi("Number",           { fg = c.copper })
hi("Boolean",          { fg = c.iron,      bold = true })
hi("Float",            { fg = c.copper })
hi("Identifier",       { fg = c.fg_dim })
hi("Function",         { fg = c.slate,     bold = true })
hi("Statement",        { fg = c.silver,    bold = true })
hi("Conditional",      { fg = c.silver,    bold = true })
hi("Repeat",           { fg = c.silver,    bold = true })
hi("Label",            { fg = c.silver })
hi("Operator",         { fg = c.fg_faint })
hi("Keyword",          { fg = c.silver,    bold = true })
hi("Exception",        { fg = c.iron,      bold = true })
hi("PreProc",          { fg = c.slate })
hi("Include",          { fg = c.slate })
hi("Define",           { fg = c.slate })
hi("Macro",            { fg = c.slate })
hi("PreCondit",        { fg = c.slate })
hi("Type",             { fg = c.fg,        bold = true })
hi("StorageClass",     { fg = c.fg })
hi("Structure",        { fg = c.fg })
hi("Typedef",          { fg = c.fg,        bold = true })
hi("Special",          { fg = c.copper })
hi("SpecialChar",      { fg = c.copper })
hi("Tag",              { fg = c.slate })
hi("Delimiter",        { fg = c.fg_faint })
hi("SpecialComment",   { fg = c.fg_faint,  italic = true })
hi("Debug",            { fg = c.iron })
hi("Underlined",       { underline = true })
hi("Ignore",           { fg = c.bg_muted })
hi("Error",            { fg = c.iron,      bold = true })
hi("Todo",             { fg = c.bg,        bg = c.copper,    bold = true })

-- ─── Treesitter ───────────────────────────────────────────────────────────────
hi("@variable",                { fg = c.fg_dim })
hi("@variable.builtin",        { fg = c.copper,    italic = true })
hi("@variable.parameter",      { fg = c.fg_dim })
hi("@variable.member",         { fg = c.fg_dim })
hi("@constant",                { fg = c.silver })
hi("@constant.builtin",        { fg = c.iron,      bold = true })
hi("@constant.macro",          { fg = c.slate })
hi("@module",                  { fg = c.slate })
hi("@string",                  { fg = c.fg })       -- pale oak, the main warmth
hi("@string.escape",           { fg = c.copper })
hi("@string.special",          { fg = c.copper })
hi("@character",               { fg = c.fg })
hi("@number",                  { fg = c.copper })
hi("@float",                   { fg = c.copper })
hi("@boolean",                 { fg = c.iron,      bold = true })
hi("@function",                { fg = c.slate,     bold = true })
hi("@function.builtin",        { fg = c.slate,     italic = true })
hi("@function.macro",          { fg = c.slate })
hi("@function.call",           { fg = c.slate })
hi("@function.method",         { fg = c.slate,     bold = true })
hi("@function.method.call",    { fg = c.slate })
hi("@constructor",             { fg = c.fg,        bold = true })
hi("@operator",                { fg = c.fg_faint })
hi("@keyword",                 { fg = c.silver,    bold = true })
hi("@keyword.function",        { fg = c.silver,    bold = true })
hi("@keyword.return",          { fg = c.iron,      bold = true })
hi("@keyword.operator",        { fg = c.fg_faint })
hi("@keyword.import",          { fg = c.slate })
hi("@keyword.conditional",     { fg = c.silver,    bold = true })
hi("@keyword.repeat",          { fg = c.silver,    bold = true })
hi("@keyword.exception",       { fg = c.iron,      bold = true })
hi("@type",                    { fg = c.fg,        bold = true })
hi("@type.builtin",            { fg = c.fg })
hi("@type.definition",         { fg = c.fg,        bold = true })
hi("@attribute",               { fg = c.slate })
hi("@property",                { fg = c.fg_dim })
hi("@comment",                 { fg = c.fg_faint,  italic = true })
hi("@comment.documentation",   { fg = c.fg_faint,  italic = true })
hi("@punctuation",             { fg = c.fg_faint })
hi("@punctuation.bracket",     { fg = c.fg_faint })
hi("@punctuation.delimiter",   { fg = c.fg_faint })
hi("@tag",                     { fg = c.slate })
hi("@tag.attribute",           { fg = c.fg })
hi("@tag.delimiter",           { fg = c.fg_faint })
hi("@markup.heading",          { fg = c.fg,        bold = true })
hi("@markup.link",             { fg = c.slate,     underline = true })
hi("@markup.link.label",       { fg = c.slate })
hi("@markup.raw",              { fg = c.copper })
hi("@markup.strong",           { bold = true })
hi("@markup.italic",           { italic = true })
hi("@diff.plus",               { fg = c.slate })
hi("@diff.minus",              { fg = c.iron })
hi("@diff.delta",              { fg = c.copper })

-- ─── LSP ──────────────────────────────────────────────────────────────────────
hi("DiagnosticError",             { fg = c.iron })
hi("DiagnosticWarn",              { fg = c.copper })
hi("DiagnosticInfo",              { fg = c.slate })
hi("DiagnosticHint",              { fg = c.fg_dim })
hi("DiagnosticOk",                { fg = c.slate })
hi("DiagnosticUnderlineError",    { undercurl = true, sp = c.iron })
hi("DiagnosticUnderlineWarn",     { undercurl = true, sp = c.copper })
hi("DiagnosticUnderlineInfo",     { undercurl = true, sp = c.slate })
hi("DiagnosticUnderlineHint",     { undercurl = true, sp = c.fg_faint })
hi("DiagnosticVirtualTextError",  { fg = c.iron,     italic = true })
hi("DiagnosticVirtualTextWarn",   { fg = c.copper,   italic = true })
hi("DiagnosticVirtualTextInfo",   { fg = c.slate,    italic = true })
hi("DiagnosticVirtualTextHint",   { fg = c.fg_dim,   italic = true })
hi("LspReferenceText",            { bg = c.bg_sel })
hi("LspReferenceRead",            { bg = c.bg_sel })
hi("LspReferenceWrite",           { bg = c.bg_sel,   underline = true })
hi("LspInlayHint",                { fg = c.fg_faint, italic = true, bg = c.bg_subtle })

-- ─── nvim-cmp ─────────────────────────────────────────────────────────────────
hi("CmpItemAbbr",           { fg = c.fg_dim })
hi("CmpItemAbbrMatch",      { fg = c.fg,       bold = true })
hi("CmpItemAbbrMatchFuzzy", { fg = c.silver })
hi("CmpItemKind",           { fg = c.slate })
hi("CmpItemMenu",           { fg = c.fg_faint })

-- ─── Telescope ────────────────────────────────────────────────────────────────
hi("TelescopeBorder",         { fg = c.bg_muted })
hi("TelescopeNormal",         { fg = c.fg_dim,  bg = c.bg_subtle })
hi("TelescopePromptBorder",   { fg = c.slate })
hi("TelescopePromptNormal",   { fg = c.fg,      bg = c.bg_subtle })
hi("TelescopePromptPrefix",   { fg = c.fg })
hi("TelescopeSelection",      { fg = c.fg,      bg = c.bg_muted })
hi("TelescopeSelectionCaret", { fg = c.copper })
hi("TelescopeMatching",       { fg = c.fg,      bold = true })
hi("TelescopePreviewTitle",   { fg = c.bg,      bg = c.slate })
hi("TelescopePromptTitle",    { fg = c.bg,      bg = c.fg })
hi("TelescopeResultsTitle",   { fg = c.bg,      bg = c.bg_muted })

-- ─── GitSigns ─────────────────────────────────────────────────────────────────
hi("GitSignsAdd",    { fg = c.slate })
hi("GitSignsChange", { fg = c.copper })
hi("GitSignsDelete", { fg = c.iron })

-- ─── Indent Blankline ─────────────────────────────────────────────────────────
hi("IblIndent", { fg = c.bg_subtle })
hi("IblScope",  { fg = c.bg_muted })

-- ─── Which-key ────────────────────────────────────────────────────────────────
hi("WhichKey",          { fg = c.fg })
hi("WhichKeyDesc",      { fg = c.fg_dim })
hi("WhichKeyGroup",     { fg = c.slate,    bold = true })
hi("WhichKeySeparator", { fg = c.fg_faint })
hi("WhichKeyFloat",     { bg = c.bg_subtle })

-- ─── Diff ─────────────────────────────────────────────────────────────────────
hi("DiffAdd",    { fg = c.slate,  bg = "#0b1317" })
hi("DiffChange", { fg = c.copper, bg = "#1a1108" })
hi("DiffDelete", { fg = c.iron,   bg = "#160805" })
hi("DiffText",   { fg = c.fg,     bg = "#2a1a0a",  bold = true })
hi("Added",      { fg = c.slate })
hi("Changed",    { fg = c.copper })
hi("Removed",    { fg = c.iron })

-- ─── Misc plugins ─────────────────────────────────────────────────────────────
hi("NvimTreeNormal",        { fg = c.fg_dim,  bg = c.bg_subtle })
hi("NvimTreeFolderIcon",    { fg = c.slate })
hi("NvimTreeRootFolder",    { fg = c.fg,      bold = true })
hi("NvimTreeGitDirty",      { fg = c.copper })
hi("NvimTreeGitNew",        { fg = c.slate })
hi("NvimTreeGitDeleted",    { fg = c.iron })
hi("NeoTreeNormal",         { fg = c.fg_dim,  bg = c.bg_subtle })
hi("NeoTreeRootName",       { fg = c.fg,      bold = true })
hi("NeoTreeGitModified",    { fg = c.copper })
hi("NeoTreeGitAdded",       { fg = c.slate })
hi("NeoTreeGitDeleted",     { fg = c.iron })
hi("FlashLabel",            { fg = c.bg,      bg = c.fg,     bold = true })
hi("FlashCurrent",          { fg = c.bg,      bg = c.copper })
hi("MiniStatuslineFilename",   { fg = c.fg_dim, bg = c.bg_muted })
hi("MiniStatuslineModeNormal", { fg = c.bg,     bg = c.fg,     bold = true })
hi("MiniStatuslineModeInsert", { fg = c.bg,     bg = c.slate,  bold = true })
hi("MiniStatuslineModeVisual", { fg = c.bg,     bg = c.copper, bold = true })
hi("NotifyERRORBorder", { fg = c.iron })
hi("NotifyERRORTitle",  { fg = c.iron,    bold = true })
hi("NotifyWARNBorder",  { fg = c.copper })
hi("NotifyWARNTitle",   { fg = c.copper,  bold = true })
hi("NotifyINFOBorder",  { fg = c.slate })
hi("NotifyINFOTitle",   { fg = c.slate,   bold = true })
