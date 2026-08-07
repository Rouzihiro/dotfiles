-- Zero-plugin file explorer (built-in netrw, tuned to feel oil-like)
vim.g.netrw_liststyle = 3 -- tree view
vim.g.netrw_banner = 0 -- hide the top banner
vim.g.netrw_winsize = 25 -- fix the left split width
vim.g.netrw_browse_split = 0 -- open files in the previous window
vim.g.netrw_altfile = 1 -- keep the alternate file correct



-- Show dotfiles/hidden files by default
-- (0 = show all, 1 = hide dotfiles, 2 = show only dotfiles — toggle with 'gh' in netrw)
vim.g.netrw_hide = 0

-- Reuse the same explorer window instead of spawning new splits every time
vim.g.netrw_altv = 1

-- Keep the current working directory in sync with wherever you browse to
vim.g.netrw_keepdir = 0
