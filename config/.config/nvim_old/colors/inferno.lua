-- inferno.lua
-- Custom Neovim colorscheme — Inferno
-- Char-black, smoldering ember, flame red, ash-pink heat.

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "inferno"
vim.o.termguicolors = true
vim.o.background = "dark"

-- ─── Palette ──────────────────────────────────────────────────────────────────
local c = {
  bg          = "#130D0C",  -- char-black, burnt wood core
  bg_subtle   = "#231412",  -- cooling ember
  bg_muted    = "#3A1C18",  -- banked fire
  bg_sel      = "#2A1210",  -- dark warm mid for selections / LSP refs
  fg          = "#EFD0C7",  -- ash-pink parchment
  fg_dim      = "#C86C57",  -- warm ember ink
  fg_faint    = "#5A2620",  -- deep coal — receding
  ash         = "#F7E1DB",  -- near-white ash — brightest highlight
  pale_ember  = "#F0B5A8",  -- pale ember — soft highlight
  ember       = "#E0A293",  -- warm pale ember
  glow        = "#D88A73",  -- ember glow — main accent
  bright_glow = "#E39580",  -- bright ember glow
  mid         = "#CF745A",  -- mid ember
  hot         = "#C86C57",  -- hot coal mid-tone
  flame       = "#D64D44",  -- flame red
  bright_flame = "#FF6A58", -- hot flame
  coal        = "#5A2620",  -- deep coal
  deep_coal   = "#70312A",  -- slightly lifted coal
  banked      = "#3A1C18",  -- banked fire (same as bg_muted, explicit alias)
  sel         = "#B55B47",  -- hot coal selection
  none        = "NONE",
}

local hi = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ─── Editor UI ────────────────────────────────────────────────────────────────
hi("Normal",           { fg = c.fg,          bg = c.bg })
hi("NormalFloat",      { fg = c.fg,          bg = c.bg_subtle })
hi("NormalNC",         { fg = c.fg_dim,      bg = c.bg })
hi("SignColumn",       { fg = c.fg_faint,    bg = c.bg })
hi("ColorColumn",      {                     bg = c.bg_subtle })
hi("CursorLine",       {                     bg = c.bg_subtle })
hi("CursorLineNr",     { fg = c.glow,        bg = c.bg_subtle, bold = true })
hi("CursorColumn",     {                     bg = c.bg_subtle })
hi("LineNr",           { fg = c.fg_faint })
hi("Cursor",           { fg = c.bg,          bg = c.glow })
hi("TermCursor",       { fg = c.bg,          bg = c.glow })
hi("Visual",           { fg = c.bg,          bg = c.sel })
hi("VisualNOS",        { fg = c.bg,          bg = c.sel })
hi("IncSearch",        { fg = c.bg,          bg = c.ash,       bold = true })
hi("Search",           { fg = c.bg,          bg = c.glow })
hi("Substitute",       { fg = c.bg,          bg = c.flame })
hi("MatchParen",       { fg = c.ash,         bg = c.none,      bold = true, underline = true })
hi("StatusLine",       { fg = c.fg_dim,      bg = c.bg_muted })
hi("StatusLineNC",     { fg = c.fg_faint,    bg = c.bg_subtle })
hi("WinSeparator",     { fg = c.bg_muted })
hi("VertSplit",        { fg = c.bg_muted })
hi("TabLine",          { fg = c.fg_faint,    bg = c.bg_subtle })
hi("TabLineFill",      {                     bg = c.bg })
hi("TabLineSel",       { fg = c.glow,        bg = c.bg_muted,  bold = true })
hi("Pmenu",            { fg = c.fg,          bg = c.bg_subtle })
hi("PmenuSel",         { fg = c.bg,          bg = c.hot,       bold = true })
hi("PmenuSbar",        {                     bg = c.bg_muted })
hi("PmenuThumb",       {                     bg = c.fg_faint })
hi("WildMenu",         { fg = c.bg,          bg = c.glow })
hi("Folded",           { fg = c.fg_dim,      bg = c.bg_subtle, italic = true })
hi("FoldColumn",       { fg = c.fg_faint,    bg = c.bg })
hi("EndOfBuffer",      { fg = c.bg_subtle })
hi("NonText",          { fg = c.bg_muted })
hi("SpecialKey",       { fg = c.bg_muted })
hi("Whitespace",       { fg = c.bg_muted })
hi("Directory",        { fg = c.glow })
hi("Title",            { fg = c.ash,         bold = true })
hi("Question",         { fg = c.glow })
hi("MoreMsg",          { fg = c.glow })
hi("ModeMsg",          { fg = c.ash,         bold = true })
hi("MsgArea",          { fg = c.fg_dim })
hi("ErrorMsg",         { fg = c.bright_flame, bold = true })
hi("WarningMsg",       { fg = c.flame })
hi("QuickFixLine",     { fg = c.bg,          bg = c.hot })
hi("SpellBad",         { undercurl = true,   sp = c.flame })
hi("SpellCap",         { undercurl = true,   sp = c.glow })
hi("SpellLocal",       { undercurl = true,   sp = c.hot })
hi("SpellRare",        { undercurl = true,   sp = c.fg_dim })

-- ─── Syntax ───────────────────────────────────────────────────────────────────
hi("Comment",          { fg = c.fg_faint,    italic = true })
hi("Constant",         { fg = c.pale_ember })
hi("String",           { fg = c.fg })         -- ash-pink — the readable warm base
hi("Character",        { fg = c.fg })
hi("Number",           { fg = c.hot })
hi("Boolean",          { fg = c.flame,       bold = true })
hi("Float",            { fg = c.hot })
hi("Identifier",       { fg = c.fg_dim })
hi("Function",         { fg = c.glow,        bold = true })
hi("Statement",        { fg = c.ash,         bold = true })
hi("Conditional",      { fg = c.ash,         bold = true })
hi("Repeat",           { fg = c.ash,         bold = true })
hi("Label",            { fg = c.ash })
hi("Operator",         { fg = c.fg_faint })
hi("Keyword",          { fg = c.ash,         bold = true })
hi("Exception",        { fg = c.flame,       bold = true })
hi("PreProc",          { fg = c.ember })
hi("Include",          { fg = c.ember })
hi("Define",           { fg = c.ember })
hi("Macro",            { fg = c.ember })
hi("PreCondit",        { fg = c.ember })
hi("Type",             { fg = c.pale_ember,  bold = true })
hi("StorageClass",     { fg = c.pale_ember })
hi("Structure",        { fg = c.pale_ember })
hi("Typedef",          { fg = c.pale_ember,  bold = true })
hi("Special",          { fg = c.mid })
hi("SpecialChar",      { fg = c.mid })
hi("Tag",              { fg = c.glow })
hi("Delimiter",        { fg = c.fg_faint })
hi("SpecialComment",   { fg = c.fg_faint,    italic = true })
hi("Debug",            { fg = c.flame })
hi("Underlined",       { underline = true })
hi("Ignore",           { fg = c.bg_muted })
hi("Error",            { fg = c.flame,       bold = true })
hi("Todo",             { fg = c.bg,          bg = c.glow,      bold = true })

-- ─── Treesitter ───────────────────────────────────────────────────────────────
hi("@variable",               { fg = c.fg_dim })
hi("@variable.builtin",       { fg = c.mid,        italic = true })
hi("@variable.parameter",     { fg = c.fg_dim })
hi("@variable.member",        { fg = c.fg_dim })
hi("@constant",               { fg = c.pale_ember })
hi("@constant.builtin",       { fg = c.flame,      bold = true })
hi("@constant.macro",         { fg = c.ember })
hi("@module",                 { fg = c.ember })
hi("@string",                 { fg = c.fg })
hi("@string.escape",          { fg = c.mid })
hi("@string.special",         { fg = c.mid })
hi("@character",              { fg = c.fg })
hi("@number",                 { fg = c.hot })
hi("@float",                  { fg = c.hot })
hi("@boolean",                { fg = c.flame,      bold = true })
hi("@function",               { fg = c.glow,       bold = true })
hi("@function.builtin",       { fg = c.glow,       italic = true })
hi("@function.macro",         { fg = c.glow })
hi("@function.call",          { fg = c.glow })
hi("@function.method",        { fg = c.glow,       bold = true })
hi("@function.method.call",   { fg = c.glow })
hi("@constructor",            { fg = c.pale_ember, bold = true })
hi("@operator",               { fg = c.fg_faint })
hi("@keyword",                { fg = c.ash,        bold = true })
hi("@keyword.function",       { fg = c.ash,        bold = true })
hi("@keyword.return",         { fg = c.flame,      bold = true })
hi("@keyword.operator",       { fg = c.fg_faint })
hi("@keyword.import",         { fg = c.ember })
hi("@keyword.conditional",    { fg = c.ash,        bold = true })
hi("@keyword.repeat",         { fg = c.ash,        bold = true })
hi("@keyword.exception",      { fg = c.flame,      bold = true })
hi("@type",                   { fg = c.pale_ember, bold = true })
hi("@type.builtin",           { fg = c.pale_ember })
hi("@type.definition",        { fg = c.pale_ember, bold = true })
hi("@attribute",              { fg = c.ember })
hi("@property",               { fg = c.fg_dim })
hi("@comment",                { fg = c.fg_faint,   italic = true })
hi("@comment.documentation",  { fg = c.fg_faint,   italic = true })
hi("@punctuation",            { fg = c.fg_faint })
hi("@punctuation.bracket",    { fg = c.fg_faint })
hi("@punctuation.delimiter",  { fg = c.fg_faint })
hi("@tag",                    { fg = c.glow })
hi("@tag.attribute",          { fg = c.fg })
hi("@tag.delimiter",          { fg = c.fg_faint })
hi("@markup.heading",         { fg = c.ash,        bold = true })
hi("@markup.link",            { fg = c.glow,       underline = true })
hi("@markup.link.label",      { fg = c.glow })
hi("@markup.raw",             { fg = c.mid })
hi("@markup.strong",          { bold = true })
hi("@markup.italic",          { italic = true })
hi("@diff.plus",              { fg = c.glow })
hi("@diff.minus",             { fg = c.flame })
hi("@diff.delta",             { fg = c.hot })

-- ─── LSP ──────────────────────────────────────────────────────────────────────
hi("DiagnosticError",             { fg = c.flame })
hi("DiagnosticWarn",              { fg = c.hot })
hi("DiagnosticInfo",              { fg = c.glow })
hi("DiagnosticHint",              { fg = c.fg_dim })
hi("DiagnosticOk",                { fg = c.glow })
hi("DiagnosticUnderlineError",    { undercurl = true, sp = c.flame })
hi("DiagnosticUnderlineWarn",     { undercurl = true, sp = c.hot })
hi("DiagnosticUnderlineInfo",     { undercurl = true, sp = c.glow })
hi("DiagnosticUnderlineHint",     { undercurl = true, sp = c.fg_faint })
hi("DiagnosticVirtualTextError",  { fg = c.flame,    italic = true })
hi("DiagnosticVirtualTextWarn",   { fg = c.hot,      italic = true })
hi("DiagnosticVirtualTextInfo",   { fg = c.glow,     italic = true })
hi("DiagnosticVirtualTextHint",   { fg = c.fg_dim,   italic = true })
hi("LspReferenceText",            { bg = c.bg_sel })
hi("LspReferenceRead",            { bg = c.bg_sel })
hi("LspReferenceWrite",           { bg = c.bg_sel,   underline = true })
hi("LspInlayHint",                { fg = c.fg_faint, italic = true, bg = c.bg_subtle })

-- ─── nvim-cmp ─────────────────────────────────────────────────────────────────
hi("CmpItemAbbr",           { fg = c.fg_dim })
hi("CmpItemAbbrMatch",      { fg = c.ash,      bold = true })
hi("CmpItemAbbrMatchFuzzy", { fg = c.pale_ember })
hi("CmpItemKind",           { fg = c.glow })
hi("CmpItemMenu",           { fg = c.fg_faint })

-- ─── Telescope ────────────────────────────────────────────────────────────────
hi("TelescopeBorder",         { fg = c.bg_muted })
hi("TelescopeNormal",         { fg = c.fg_dim,   bg = c.bg_subtle })
hi("TelescopePromptBorder",   { fg = c.hot })
hi("TelescopePromptNormal",   { fg = c.fg,       bg = c.bg_subtle })
hi("TelescopePromptPrefix",   { fg = c.glow })
hi("TelescopeSelection",      { fg = c.bg,       bg = c.sel })
hi("TelescopeSelectionCaret", { fg = c.ash })
hi("TelescopeMatching",       { fg = c.ash,      bold = true })
hi("TelescopePreviewTitle",   { fg = c.bg,       bg = c.hot })
hi("TelescopePromptTitle",    { fg = c.bg,       bg = c.glow })
hi("TelescopeResultsTitle",   { fg = c.bg,       bg = c.bg_muted })

-- ─── GitSigns ─────────────────────────────────────────────────────────────────
hi("GitSignsAdd",    { fg = c.glow })
hi("GitSignsChange", { fg = c.hot })
hi("GitSignsDelete", { fg = c.flame })

-- ─── Indent Blankline ─────────────────────────────────────────────────────────
hi("IblIndent", { fg = c.bg_subtle })
hi("IblScope",  { fg = c.bg_muted })

-- ─── Which-key ────────────────────────────────────────────────────────────────
hi("WhichKey",          { fg = c.glow })
hi("WhichKeyDesc",      { fg = c.fg_dim })
hi("WhichKeyGroup",     { fg = c.hot,      bold = true })
hi("WhichKeySeparator", { fg = c.fg_faint })
hi("WhichKeyFloat",     { bg = c.bg_subtle })

-- ─── Diff ─────────────────────────────────────────────────────────────────────
hi("DiffAdd",    { fg = c.glow,   bg = "#180e0d" })
hi("DiffChange", { fg = c.hot,    bg = "#1a0e0c" })
hi("DiffDelete", { fg = c.flame,  bg = "#1c0908" })
hi("DiffText",   { fg = c.ash,    bg = "#2a1210",  bold = true })
hi("Added",      { fg = c.glow })
hi("Changed",    { fg = c.hot })
hi("Removed",    { fg = c.flame })

-- ─── Misc plugins ─────────────────────────────────────────────────────────────
hi("NvimTreeNormal",        { fg = c.fg_dim,  bg = c.bg_subtle })
hi("NvimTreeFolderIcon",    { fg = c.glow })
hi("NvimTreeRootFolder",    { fg = c.ash,     bold = true })
hi("NvimTreeGitDirty",      { fg = c.hot })
hi("NvimTreeGitNew",        { fg = c.glow })
hi("NvimTreeGitDeleted",    { fg = c.flame })
hi("NeoTreeNormal",         { fg = c.fg_dim,  bg = c.bg_subtle })
hi("NeoTreeRootName",       { fg = c.ash,     bold = true })
hi("NeoTreeGitModified",    { fg = c.hot })
hi("NeoTreeGitAdded",       { fg = c.glow })
hi("NeoTreeGitDeleted",     { fg = c.flame })
hi("FlashLabel",            { fg = c.bg,      bg = c.ash,    bold = true })
hi("FlashCurrent",          { fg = c.bg,      bg = c.flame })
hi("MiniStatuslineFilename",   { fg = c.fg_dim,  bg = c.bg_muted })
hi("MiniStatuslineModeNormal", { fg = c.bg,      bg = c.glow,   bold = true })
hi("MiniStatuslineModeInsert", { fg = c.bg,      bg = c.hot,    bold = true })
hi("MiniStatuslineModeVisual", { fg = c.bg,      bg = c.flame,  bold = true })
hi("NotifyERRORBorder", { fg = c.flame })
hi("NotifyERRORTitle",  { fg = c.flame,   bold = true })
hi("NotifyWARNBorder",  { fg = c.hot })
hi("NotifyWARNTitle",   { fg = c.hot,     bold = true })
hi("NotifyINFOBorder",  { fg = c.glow })
hi("NotifyINFOTitle",   { fg = c.glow,    bold = true })
