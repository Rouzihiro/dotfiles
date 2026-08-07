-- gilded.lua
-- Custom Neovim colorscheme — Gilded
-- Ancient gold, ember amber, aged parchment, candlelit darkness.
-- Drop into ~/.config/nvim/colors/gilded.lua

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "gilded"
vim.o.termguicolors = true
vim.o.background = "dark"

-- ─── Palette ──────────────────────────────────────────────────────────────────
local c = {
  bg          = "#0B0D0A",  -- near-black, green-black undertone
  bg_subtle   = "#17140E",  -- lifted dark — vellum shadow
  bg_muted    = "#2A2318",  -- amber-tinged dark
  bg_sel      = "#221B0D",  -- warm dark for selections / LSP refs
  fg          = "#EFE2C7",  -- pale parchment
  fg_dim      = "#B86A22",  -- warm amber ink
  fg_faint    = "#5C4A2A",  -- faded inscription
  cream       = "#FFF1CF",  -- bright white — candleflame highlight
  bright_gold = "#F0BF6B",  -- bright gold — emphasis
  gold        = "#D19A45",  -- gilded gold — main accent
  amber       = "#CA8732",  -- amber — secondary warm
  ember       = "#C86B2B",  -- ember orange
  sienna      = "#A15C1D",  -- burnt sienna — error / danger
  deep_ember  = "#894418",  -- deep ember — darkest warm
  none        = "NONE",
}

local hi = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ─── Editor UI ────────────────────────────────────────────────────────────────
hi("Normal",           { fg = c.fg,         bg = c.bg })
hi("NormalFloat",      { fg = c.fg,         bg = c.bg_subtle })
hi("NormalNC",         { fg = c.fg_dim,     bg = c.bg })
hi("SignColumn",       { fg = c.fg_faint,   bg = c.bg })
hi("ColorColumn",      {                    bg = c.bg_subtle })
hi("CursorLine",       {                    bg = c.bg_subtle })
hi("CursorLineNr",     { fg = c.gold,       bg = c.bg_subtle, bold = true })
hi("CursorColumn",     {                    bg = c.bg_subtle })
hi("LineNr",           { fg = c.fg_faint })
hi("Cursor",           { fg = c.bg,         bg = c.gold })
hi("TermCursor",       { fg = c.bg,         bg = c.gold })
hi("Visual",           { fg = c.bg,         bg = c.gold })
hi("VisualNOS",        { fg = c.bg,         bg = c.gold })
hi("IncSearch",        { fg = c.bg,         bg = c.bright_gold, bold = true })
hi("Search",           { fg = c.bg,         bg = c.gold })
hi("Substitute",       { fg = c.bg,         bg = c.ember })
hi("MatchParen",       { fg = c.bright_gold, bg = c.none,      bold = true, underline = true })
hi("StatusLine",       { fg = c.fg_dim,     bg = c.bg_muted })
hi("StatusLineNC",     { fg = c.fg_faint,   bg = c.bg_subtle })
hi("WinSeparator",     { fg = c.bg_muted })
hi("VertSplit",        { fg = c.bg_muted })
hi("TabLine",          { fg = c.fg_faint,   bg = c.bg_subtle })
hi("TabLineFill",      {                    bg = c.bg })
hi("TabLineSel",       { fg = c.gold,       bg = c.bg_muted,   bold = true })
hi("Pmenu",            { fg = c.fg,         bg = c.bg_subtle })
hi("PmenuSel",         { fg = c.bg,         bg = c.amber,      bold = true })
hi("PmenuSbar",        {                    bg = c.bg_muted })
hi("PmenuThumb",       {                    bg = c.fg_faint })
hi("WildMenu",         { fg = c.bg,         bg = c.gold })
hi("Folded",           { fg = c.fg_dim,     bg = c.bg_subtle,  italic = true })
hi("FoldColumn",       { fg = c.fg_faint,   bg = c.bg })
hi("EndOfBuffer",      { fg = c.bg_subtle })
hi("NonText",          { fg = c.bg_muted })
hi("SpecialKey",       { fg = c.bg_muted })
hi("Whitespace",       { fg = c.bg_muted })
hi("Directory",        { fg = c.amber })
hi("Title",            { fg = c.gold,       bold = true })
hi("Question",         { fg = c.amber })
hi("MoreMsg",          { fg = c.amber })
hi("ModeMsg",          { fg = c.gold,       bold = true })
hi("MsgArea",          { fg = c.fg_dim })
hi("ErrorMsg",         { fg = c.sienna,     bold = true })
hi("WarningMsg",       { fg = c.ember })
hi("QuickFixLine",     { fg = c.bg,         bg = c.amber })
hi("SpellBad",         { undercurl = true,  sp = c.sienna })
hi("SpellCap",         { undercurl = true,  sp = c.amber })
hi("SpellLocal",       { undercurl = true,  sp = c.gold })
hi("SpellRare",        { undercurl = true,  sp = c.fg_dim })

-- ─── Syntax ───────────────────────────────────────────────────────────────────
hi("Comment",          { fg = c.fg_faint,   italic = true })
hi("Constant",         { fg = c.bright_gold })
hi("String",           { fg = c.fg })         -- parchment — warm and legible
hi("Character",        { fg = c.fg })
hi("Number",           { fg = c.amber })
hi("Boolean",          { fg = c.ember,      bold = true })
hi("Float",            { fg = c.amber })
hi("Identifier",       { fg = c.fg_dim })
hi("Function",         { fg = c.gold,       bold = true })
hi("Statement",        { fg = c.cream,      bold = true })
hi("Conditional",      { fg = c.cream,      bold = true })
hi("Repeat",           { fg = c.cream,      bold = true })
hi("Label",            { fg = c.cream })
hi("Operator",         { fg = c.fg_faint })
hi("Keyword",          { fg = c.cream,      bold = true })
hi("Exception",        { fg = c.sienna,     bold = true })
hi("PreProc",          { fg = c.amber })
hi("Include",          { fg = c.amber })
hi("Define",           { fg = c.amber })
hi("Macro",            { fg = c.amber })
hi("PreCondit",        { fg = c.amber })
hi("Type",             { fg = c.bright_gold, bold = true })
hi("StorageClass",     { fg = c.bright_gold })
hi("Structure",        { fg = c.bright_gold })
hi("Typedef",          { fg = c.bright_gold, bold = true })
hi("Special",          { fg = c.ember })
hi("SpecialChar",      { fg = c.ember })
hi("Tag",              { fg = c.amber })
hi("Delimiter",        { fg = c.fg_faint })
hi("SpecialComment",   { fg = c.fg_faint,   italic = true })
hi("Debug",            { fg = c.sienna })
hi("Underlined",       { underline = true })
hi("Ignore",           { fg = c.bg_muted })
hi("Error",            { fg = c.sienna,     bold = true })
hi("Todo",             { fg = c.bg,         bg = c.gold,       bold = true })

-- ─── Treesitter ───────────────────────────────────────────────────────────────
hi("@variable",               { fg = c.fg_dim })
hi("@variable.builtin",       { fg = c.ember,      italic = true })
hi("@variable.parameter",     { fg = c.fg_dim })
hi("@variable.member",        { fg = c.fg_dim })
hi("@constant",               { fg = c.bright_gold })
hi("@constant.builtin",       { fg = c.ember,      bold = true })
hi("@constant.macro",         { fg = c.amber })
hi("@module",                 { fg = c.amber })
hi("@string",                 { fg = c.fg })
hi("@string.escape",          { fg = c.ember })
hi("@string.special",         { fg = c.ember })
hi("@character",              { fg = c.fg })
hi("@number",                 { fg = c.amber })
hi("@float",                  { fg = c.amber })
hi("@boolean",                { fg = c.ember,      bold = true })
hi("@function",               { fg = c.gold,       bold = true })
hi("@function.builtin",       { fg = c.gold,       italic = true })
hi("@function.macro",         { fg = c.gold })
hi("@function.call",          { fg = c.gold })
hi("@function.method",        { fg = c.gold,       bold = true })
hi("@function.method.call",   { fg = c.gold })
hi("@constructor",            { fg = c.bright_gold, bold = true })
hi("@operator",               { fg = c.fg_faint })
hi("@keyword",                { fg = c.cream,      bold = true })
hi("@keyword.function",       { fg = c.cream,      bold = true })
hi("@keyword.return",         { fg = c.ember,      bold = true })
hi("@keyword.operator",       { fg = c.fg_faint })
hi("@keyword.import",         { fg = c.amber })
hi("@keyword.conditional",    { fg = c.cream,      bold = true })
hi("@keyword.repeat",         { fg = c.cream,      bold = true })
hi("@keyword.exception",      { fg = c.sienna,     bold = true })
hi("@type",                   { fg = c.bright_gold, bold = true })
hi("@type.builtin",           { fg = c.bright_gold })
hi("@type.definition",        { fg = c.bright_gold, bold = true })
hi("@attribute",              { fg = c.amber })
hi("@property",               { fg = c.fg_dim })
hi("@comment",                { fg = c.fg_faint,   italic = true })
hi("@comment.documentation",  { fg = c.fg_faint,   italic = true })
hi("@punctuation",            { fg = c.fg_faint })
hi("@punctuation.bracket",    { fg = c.fg_faint })
hi("@punctuation.delimiter",  { fg = c.fg_faint })
hi("@tag",                    { fg = c.amber })
hi("@tag.attribute",          { fg = c.fg })
hi("@tag.delimiter",          { fg = c.fg_faint })
hi("@markup.heading",         { fg = c.gold,       bold = true })
hi("@markup.link",            { fg = c.amber,      underline = true })
hi("@markup.link.label",      { fg = c.amber })
hi("@markup.raw",             { fg = c.ember })
hi("@markup.strong",          { bold = true })
hi("@markup.italic",          { italic = true })
hi("@diff.plus",              { fg = c.amber })
hi("@diff.minus",             { fg = c.sienna })
hi("@diff.delta",             { fg = c.gold })

-- ─── LSP ──────────────────────────────────────────────────────────────────────
hi("DiagnosticError",             { fg = c.sienna })
hi("DiagnosticWarn",              { fg = c.ember })
hi("DiagnosticInfo",              { fg = c.gold })
hi("DiagnosticHint",              { fg = c.fg_dim })
hi("DiagnosticOk",                { fg = c.amber })
hi("DiagnosticUnderlineError",    { undercurl = true, sp = c.sienna })
hi("DiagnosticUnderlineWarn",     { undercurl = true, sp = c.ember })
hi("DiagnosticUnderlineInfo",     { undercurl = true, sp = c.gold })
hi("DiagnosticUnderlineHint",     { undercurl = true, sp = c.fg_faint })
hi("DiagnosticVirtualTextError",  { fg = c.sienna,   italic = true })
hi("DiagnosticVirtualTextWarn",   { fg = c.ember,    italic = true })
hi("DiagnosticVirtualTextInfo",   { fg = c.gold,     italic = true })
hi("DiagnosticVirtualTextHint",   { fg = c.fg_dim,   italic = true })
hi("LspReferenceText",            { bg = c.bg_sel })
hi("LspReferenceRead",            { bg = c.bg_sel })
hi("LspReferenceWrite",           { bg = c.bg_sel,   underline = true })
hi("LspInlayHint",                { fg = c.fg_faint, italic = true, bg = c.bg_subtle })

-- ─── nvim-cmp ─────────────────────────────────────────────────────────────────
hi("CmpItemAbbr",           { fg = c.fg_dim })
hi("CmpItemAbbrMatch",      { fg = c.gold,     bold = true })
hi("CmpItemAbbrMatchFuzzy", { fg = c.amber })
hi("CmpItemKind",           { fg = c.amber })
hi("CmpItemMenu",           { fg = c.fg_faint })

-- ─── Telescope ────────────────────────────────────────────────────────────────
hi("TelescopeBorder",         { fg = c.bg_muted })
hi("TelescopeNormal",         { fg = c.fg_dim,   bg = c.bg_subtle })
hi("TelescopePromptBorder",   { fg = c.amber })
hi("TelescopePromptNormal",   { fg = c.fg,       bg = c.bg_subtle })
hi("TelescopePromptPrefix",   { fg = c.gold })
hi("TelescopeSelection",      { fg = c.bg,       bg = c.amber })
hi("TelescopeSelectionCaret", { fg = c.gold })
hi("TelescopeMatching",       { fg = c.gold,     bold = true })
hi("TelescopePreviewTitle",   { fg = c.bg,       bg = c.amber })
hi("TelescopePromptTitle",    { fg = c.bg,       bg = c.gold })
hi("TelescopeResultsTitle",   { fg = c.bg,       bg = c.bg_muted })

-- ─── GitSigns ─────────────────────────────────────────────────────────────────
hi("GitSignsAdd",    { fg = c.amber })
hi("GitSignsChange", { fg = c.gold })
hi("GitSignsDelete", { fg = c.sienna })

-- ─── Indent Blankline ─────────────────────────────────────────────────────────
hi("IblIndent", { fg = c.bg_subtle })
hi("IblScope",  { fg = c.bg_muted })

-- ─── Which-key ────────────────────────────────────────────────────────────────
hi("WhichKey",          { fg = c.gold })
hi("WhichKeyDesc",      { fg = c.fg_dim })
hi("WhichKeyGroup",     { fg = c.amber,    bold = true })
hi("WhichKeySeparator", { fg = c.fg_faint })
hi("WhichKeyFloat",     { bg = c.bg_subtle })

-- ─── Diff ─────────────────────────────────────────────────────────────────────
hi("DiffAdd",    { fg = c.amber,   bg = "#111008" })
hi("DiffChange", { fg = c.gold,    bg = "#1a1508" })
hi("DiffDelete", { fg = c.sienna,  bg = "#140a04" })
hi("DiffText",   { fg = c.cream,   bg = "#231c09",  bold = true })
hi("Added",      { fg = c.amber })
hi("Changed",    { fg = c.gold })
hi("Removed",    { fg = c.sienna })

-- ─── Misc plugins ─────────────────────────────────────────────────────────────
hi("NvimTreeNormal",        { fg = c.fg_dim,  bg = c.bg_subtle })
hi("NvimTreeFolderIcon",    { fg = c.amber })
hi("NvimTreeRootFolder",    { fg = c.gold,    bold = true })
hi("NvimTreeGitDirty",      { fg = c.gold })
hi("NvimTreeGitNew",        { fg = c.amber })
hi("NvimTreeGitDeleted",    { fg = c.sienna })
hi("NeoTreeNormal",         { fg = c.fg_dim,  bg = c.bg_subtle })
hi("NeoTreeRootName",       { fg = c.gold,    bold = true })
hi("NeoTreeGitModified",    { fg = c.gold })
hi("NeoTreeGitAdded",       { fg = c.amber })
hi("NeoTreeGitDeleted",     { fg = c.sienna })
hi("FlashLabel",            { fg = c.bg,      bg = c.bright_gold, bold = true })
hi("FlashCurrent",          { fg = c.bg,      bg = c.ember })
hi("MiniStatuslineFilename",   { fg = c.fg_dim,  bg = c.bg_muted })
hi("MiniStatuslineModeNormal", { fg = c.bg,      bg = c.gold,    bold = true })
hi("MiniStatuslineModeInsert", { fg = c.bg,      bg = c.amber,   bold = true })
hi("MiniStatuslineModeVisual", { fg = c.bg,      bg = c.ember,   bold = true })
hi("NotifyERRORBorder", { fg = c.sienna })
hi("NotifyERRORTitle",  { fg = c.sienna,  bold = true })
hi("NotifyWARNBorder",  { fg = c.ember })
hi("NotifyWARNTitle",   { fg = c.ember,   bold = true })
hi("NotifyINFOBorder",  { fg = c.gold })
hi("NotifyINFOTitle",   { fg = c.gold,    bold = true })

