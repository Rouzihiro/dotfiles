" Disable LTeX specifically for emails
if exists('*ltex#disable')
  call ltex#disable()
endif

setlocal nospell

" Mail-specific settings
setlocal wrap
setlocal linebreak
setlocal spell
setlocal conceallevel=2
setlocal colorcolumn=72
syntax match EmailQuotes /^>.*/ 
hi EmailQuotes guifg=#458588

" Keymaps
nnoremap q :q<CR>  " Quick exit
vnoremap <leader>p "+y  " Copy to clipboard
