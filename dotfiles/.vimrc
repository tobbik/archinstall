" -----------------------------------
"" general settings
" -----------------------------------
set nocompatible
" a specific backupdir makes sure you don'd have flying around all these
" dead backup files -> clean up the dir frequently
"set backup
"set backupdir=$HOME/.vim/backupdir
" ...or use
set nobackup

set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

""""""""""""""""""""""""""""""""""""""""""
"" Eye candy and geometry
""""""""""""""""""""""""""""""""""""""""""
if $TERM == 'rxvt-unicode-256color'
  set t_Co=256
elseif $TERM == 'screen-256color'
  set t_Co=256
elseif $COLORFGBG =~ 'default;default'
  " a fallback for mlterm and other terms
  set t_Co=16
  set t_AB=[%?%p1%{8}%<%t25;%p1%{40}%+%e5;%p1%{32}%+%;%dm
  set t_AF=[%?%p1%{8}%<%t22;%p1%{30}%+%e1;%p1%{22}%+%;%dm
else 
  " xterm has neither variable set ...
  set t_Co=256
endif

" Now when vim knows terminal capabilities, we start colorizing
if has("gui_running")
  colorscheme wombat256mod
else
  colorscheme wombat256mod
  "colorscheme desert
endif
set background=dark
set syntax=on
set previewheight=5
set textwidth=0
" set nowrap
set ruler

set cursorline
hi CursorLine cterm=NONE ctermbg=8
hi MatchParen ctermbg=13
hi CursorColumn ctermbg=17

" autoindenting (local to buffer)
set ai
" smartindenting (clever autoindenting)
set si
" number of spaces the tab stands for
set tabstop=3
" number of spaces used for (auto)indenting
set shiftwidth=3
" If we find tabs we wanna preserve them and don't convert to spaces
set noexpandtab
" a <tab> in an indent insets 'shiftwidth' spaces (not tabstop)
set nosmarttab
" if non-zero, number of spaces to insert for a <tab>
set softtabstop=3
" enable specific indenting for c-code and others
set cindent


set spelllang=en

" some settings and other shortcuts...
set wmh=0
set ic
" map <F8>  :w<C-M>
set pastetoggle=<F9>
set ttyfast
set title

" shift key somtimes needs a bit to release
command WQ wq

" Search and substitute
" highlight matches
set hls
" highlight while typing
set incsearch
" jump to matches on typing pattern
set sm
" automatically start over at EOF
set wrapscan
" case-insenitiv search
set ignorecase
" case insensitive if uppercase chars in pattern
set scs
" g-flag default -> replace all matches in a line
"set gdefault



"""""""""""""""""""""""""""""""""""""""""""""""""
"" set visible whitespaces
"""""""""""""""""""""""""""""""""""""""""""""""""
"set listchars=tab:└─,trail:•∙▪•◇○●◯
set listchars=tab:└─,trail:•
set list
nnoremap \tl :set invlist list?<CR>
nmap <F2> \tl

"""""""""""""""""""""""""""""""""""""""""""""""""
"" mouse in vim
"""""""""""""""""""""""""""""""""""""""""""""""""
set mouse=a

"""""""""""""""""""""""""""""""""""""""""""""""""
"" some other nice settings ...
"""""""""""""""""""""""""""""""""""""""""""""""""
" line numbers always on
set number
" exclude filetypes from browse listings
let g:netrw_list_hide='\.pyc$,\.swp$'

function! ToggleGUICruft( )
  if &guioptions=='ai'
    exec( 'set guioptions=aimrL' )
  else
    exec( 'set guioptions=ai' )
  endif
endfunction
if has( 'gui_running' )
" GUI options
  set guifont=DejaVu\ Sans\ Mono\ 12
  set guitablabel=%N\ %t\ %m
  set background=dark
  map <S-Insert> <MiddleMouse>
  map <M-n> :tabnext<CR>
  map <M-p> :tabprev<CR>
  set co=90
  set lines=46
  map <F4> <Esc>:call ToggleGUICruft()<cr>
  set guioptions=ai            "minimal gui, no toolbar
endif

" execute a local .vimrc file within a pwd where vim is started
set secure exrc

"au BufNewFile,BufRead * nested
"  \ if &buftype != "help" |
"  \   tab sball |
"  \ endif

