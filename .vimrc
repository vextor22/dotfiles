syntax enable
set relativenumber
set background=dark
set backspace=indent,eol,start
set mousemodel=popup
let no_buffers_menu=1
"" Disable the blinking cursor.
set gcr=a:blinkon0
set scrolloff=3
set noshowmode

"" Use modeline overrides
set modeline
set modelines=10
let mapleader = ","
set tabstop=2       " number of visual spaces per TAB
set softtabstop=2   " number of spaces in tab when editing
set shiftwidth=4
set expandtab       " tabs are spaces
set number              " show line numbers
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
filetype indent on      " load filetype-specific indent files
filetype plugin on
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
nnoremap <leader><space> :nohlsearch<CR>
colorscheme PaperColor
set laststatus=2
set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\
set statusline+=%{FugitiveStatusline()}
let g:lightline = {
      \ 'colorscheme': 'PaperColor',
      \ 'background': 'dark',
      \ }

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv


map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

let g:go_fmt_command = "goimports"
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)

execute pathogen#infect()
let g:ale_elm_ls_use_global = 1
let g:ycm_semantic_triggers = {
     \ 'elm' : ['.'],
     \}
au VimEnter * NERDTree
au VimLeave * NERDTreeClose
au VimResized * wincmd = 

let g:user_emmet_leader_key='<c-y>'

let python_highlight_space_errors=0
