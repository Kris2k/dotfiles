""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""
set nocompatible
set showcmd
set spelllang=en,pl
set statusline=%.80f%0*[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%y%r%m%=%l/%L\ %c\ %p%%

set title
set titleold=

set modeline
set incsearch
set hlsearch
set history=100

set relativenumber
set softtabstop=4
set shiftwidth=4
set shiftround
set tabstop=4
set expandtab smarttab
let g:tex_flavor='latex'

set autoread                                           " auto read when a file is changed from outside
set hidden                                             " warn on exit with unsaved changes

set backspace=indent,eol,start
set whichwrap+=<,>,h,l
set linebreak

set ignorecase                                         " Ignore case when searching
set smartcase

set laststatus=2                                       " commandline display and tab in cmdline
set wildchar=<Tab> wildmenu wildmode=list:longest,full

set clipboard+=unnamed                                 " yanks go to system clipboard too and back on Focus
autocmd FocusGained * let @z=@+

set matchpairs+=<:>
set showmatch                                          " show the matching bracket on when inserting
set timeoutlen=250

set nobackup                                           " do not create backup file
set nowritebackup                                      " no create backup when overwriting file
set noswapfile                                         " enabled to prevent double editing

if !has("gui_running") && !has('win32') && !has('win64')
    set term=$TERM       " Make arrow and other keys work
endif

if &term =~ "xterm"
  let &t_ti = &t_ti . "\e[?2004h"
  let &t_te = "\e[?2004l" . &t_te
  let pastetoggle = "\e[2001~"
  function! XTermPasteBegin(ret)
    set pastetoggle=<esc>[201~
    set paste
    return a:ret
  endfunction
  noremap  <special><expr> <Esc>[200~ XTermPasteBegin("i")
  inoremap <special><expr> <Esc>[200~ XTermPasteBegin("")
  cnoremap <special> <Esc>[200~ <nop>
  cnoremap <special> <Esc>[201~ <nop>
endif

if  &term =~ "linux" || &term =~ "cons25"
  set term=$TERM
  colorscheme desert
elseif &term =~ "256" || has("gui_running") ||  &term =~ 'screen' || &term =~ 'xterm'
  set t_Co=256
  colorscheme kchrisk
else
  colorscheme darkblue
endif

if !isdirectory($HOME . '/.vim/tmp/swap')
    call mkdir($HOME . '/.vim/tmp/swap', 'p', 0700)
endif
set dir=$HOME/.vim/tmp/swap

if has("persistent_undo")
    if !isdirectory($HOME. '/.vim/tmp/undo')
        call mkdir($HOME. '/.vim/tmp/undo', 'p', 0700)
    endif
    set undodir=$HOME/.vim/tmp/undo
    set undofile
endif

if has("gui_running")
    set mouse=a
    vnoremap <LeftRelease> "+y<LeftRelease>
    " no buffer menu for me
    let no_buffers_menu = 1
    " disable  menu, Toolbar, Left scorllbar
    set guioptions -=m
    set guioptions -=T
    set guioptions -=L
    set fileencodings=utf-8
    " windows is stuipid so you can use cp1250
    set encoding=utf-8
    " set fileencodings=ucs-bom,utf-8,latin1
    " polis settings for gui
endif

if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
    set termencoding=utf8
endif

"""""""""""""""""""""""""
" => cscope database auto add see :help cscopequickfix
"""""""""""""""""""""""""
if has("cscope") && ( filereadable('/usr/bin/cscope') ||
      \ filereadable('/usr/local/bin/cscope') )
    " nice cscope menu see help
    set cscopequickfix=s-,g-,c-,d-,i-,t-,e-
    " set csprg=system("which cscope")
    set csto=0
    set cst
    " add cscope database local or form env
    set nocsverb
    if filereadable("cscope.out")
        cs add cscope.out
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set csverb
endif

" -I ignore binary files -Hn is for printing file name and line number
set grepprg=grep\ -Hn\ -I\ --exclude-dir='.svn'\ --exclude-dir='.git'\ --exclude-dir='po'\ --exclude='tags*'\ --exclude='cscope.*'\ --exclude='*.html'\ --exclude-dir='.waf-*'\ -r

" set binary
" set noeol
" set cpoptions+={
" setlocal fo+=aw for vim mutt

" set colorcolumn=80
" set list
" set listchars=tab:.-

""""""""""""""""""""""""""""""
" => Pathogen plugin
"""""""""""""""""""""""""""""""
source ~/.vim/bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()
syntax enable
filetype plugin indent on

" add xpt templates personal folder to runtimepath
" let &runtimepath .=',~/.vim/personal'


""""""""""""""""""""""""""""""
" => Per host settings
"""""""""""""""""""""""""""""""
let hostfile = $HOME . '/.vim/.vimrc-' . substitute(hostname(), "\\..*", "", "")
if filereadable(hostfile)
  exe 'source ' . hostfile
endif

" Fast exit from insert mode
inoremap jk <Esc>
inoremap JK <Esc>
inoremap Jk <Esc>
inoremap jK <Esc>


" insert empty line fast
nnoremap [<space>  :put! =''<cr>
nnoremap ]<space>  :put =''<cr>

" make search go only forward
nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]

" Wrapped lines goes down/up to next row, rather than next line in file.
"nnoremap j gj
"nnoremap k gk

"""""""""""""""""""""""""
" => tmux-vim plugin
"""""""""""""""""""""""""
" this works for xterm keyboard settings
set <m-h> =h
set <m-j> =j
set <m-k> =k
set <m-l> =l

let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <m-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <m-j> :TmuxNavigateDown<cr>
nnoremap <silent> <m-k> :TmuxNavigateUp<cr>
nnoremap <silent> <m-l> :TmuxNavigateRight<cr>

" fix meta-keys which generate <Esc>a .. <Esc>z
" let c='a'
" while c <= 'z'
"   exec "set <M-".toupper(c).">=\e".c
"   exec "inoremap \e".c." <M-".toupper(c).">"
"   let c = nr2char(1+char2nr(c))
" endw
inoremap <m-k> <esc>k
inoremap <m-j> <esc>j
inoremap <m-h> <esc>h
inoremap <m-l> <esc>l
""""""""""""""""""""""""""""""""""
" => Highglight formating
""""""""""""""""""""""""""""""""""
" Gent00 leave my text files alone,
let g:leave_my_textwidth_alone = 1
" https://github.com/bitc/vim-bad-whitespace/blob/master/plugin/bad-whitespace.vim

""""""""""""""""""""""""""""""
" => helper functions
"""""""""""""""""""""""""""""""
function! GetBufferList()
  redir =>buflist
  silent! ls
  redir END
  return buflist
endfunction

"quickfix hack
function! ToggleList(bufname, pfx,num,switchTo)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
        exec(a:pfx.'close')
        return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
    echohl ErrorMsg
    echo "Location List is Empty."
    return
  endif
  let winnr = winnr()
  exec('botright '.a:pfx.'open'.' '.a:num)
  if winnr() != winnr
    if a:switchTo == 'yes'
      wincmd p
    endif
  endif
endfunction

" Quick fix list window
function! EnqfL(num)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "Quickfix List"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1 | return | endif
  endfor
  let winnr = winnr()
  exec('botright copen '.a:num)
  if winnr() != winnr | wincmd p | endif
endfunction

function! SetMakePrg()
  if filereadable('.projectLite.vim') | return | endif
  if &ft == 'go' | setlocal makeprg=go\ run\ % | endif
  if filereadable('wscript') | setlocal makeprg=./waf\ --alltests | endif
  if filereadable('bam.lua')
      \ && filereadable('./bam') | setlocal makeprg='./bam' | endif

  if glob('?akefile') != '' | setlocal makeprg=make\ -j4\ $* | endif
  if bufname("%") =~ ".*\.tex" | setlocal makeprg=latexmk\ -pdf | endif
  if bufname("%") =~ ".*\.java" | setlocal makeprg=javac\ % | endif
  if bufname("%") =~ ".*\.c$" | setlocal makeprg=gcc\ -Wall\ -g\ -std=c99\ % | endif
  if  bufname("%") =~ ".*\.cpp" | setlocal makeprg=g++\ -g\ -Wall\ -std=c++11\ % | endif
endfunction

function! ClearMarksAndSearchs()
  let @/=""
  :MarkClear
  :diffupdate
  :syntax sync fromstart
endfunction

"Function for opening files
function! NiceOpen(fname)
    exec("edit ". strtrans(a:fname))
endfunction

let g:markState = 1
function! ToggleMarkSearch()
  if g:markState
    nmap <Plug>IgnoreMarkSearchNext <Plug>MarkSearchNext
    nmap <Plug>IgnoreMarkSearchPrev <Plug>MarkSearchPrev
    let g:markState = 1
  else
    unmap <Plug>IgnoreMarkSearchNext
    unmap <Plug>IgnoreMarkSearchPrev
    let g:markState = 0
  endif
endfunction

function! StripWhitespace()
  let cur_pos = getpos('.')
  let _s=@/
  s/\s\+$//e
  let @/=_s
  call setpos('.', cur_pos)
endfunction

function! NumberInv()
  if &relativenumber| set nornu number | return | endif
  if &number| set nonumber nornu | return
  else | set relativenumber | return | endif
endfunction

function! ColorColumn()
  if ! &colorcolumn| set colorcolumn=78
  else | set colorcolumn=0 | endif
endfunction

""""""""""""""""""""""""""""""
" => mapleader
"""""""""""""""""""""""""""""""
" Space mapleader hack
" I set leader as '_' but I map space to leader
" This will show space in showcmd window on the bottom but printed as '_'
let mapleader='_'
map <Space> <leader>
map <Space><Space> <leader><leader>
let maplocalleader = "\\"

" FIXME: this hack works for gnu screen problems when invoked make
nnoremap <leader><leader> :make <cr>
nnoremap <silent> <leader>, :let @/=""<cr>
nnoremap <silent> <leader>w :w!<cr>
nnoremap <silent> <leader>ss :cscope reset<cr>
nmap <silent> <leader>c <Plug>CommentaryLine
xmap <silent> <leader>c <Plug>Commentary
""Fast vimrc access
nnoremap <silent> <leader>eu :call NiceOpen("/etc/portage/package.use")<cr>
nnoremap <silent> <leader>em :call NiceOpen("/etc/portage/make.conf")<cr>
nnoremap <silent> <leader>ev :call NiceOpen("$HOME/.vimrc")<cr>
nnoremap <silent> <leader>et :call NiceOpen("$HOME/.tmux.conf")<cr>
nnoremap <silent> <leader>es :call NiceOpen("$HOME/.screenrc")<cr>
nnoremap <silent> <leader>ez :call NiceOpen("$HOME/.zshrc")<cr>
nnoremap <silent> <leader>eg :call NiceOpen("$HOME/.gitconfig")<cr>
nnoremap <silent> <leader>eh :call NiceOpen("$HOME/.ssh/config")<cr>
nnoremap <silent> <leader>en :call NiceOpen("$HOME/notes/notes-programing.txt")<cr>
nnoremap <silent> <leader>ex :call NiceOpen("$HOME/.Xresources")<cr>



" nnoremap <silent> <leader>8 :set nois;<esc>/<c-r><c-w><cr>
" hack for vimrc prototyping just type command and exec it
nnoremap <silent> <leader>; :exec(getline('.'))<cr>

nnoremap <silent> <leader>q :call ToggleList("Quickfix List", 'c','20','no')<CR>
nnoremap <silent> <Leader>j :call EnqfL('5')<cr>:cnext<cr>
nnoremap <silent> <Leader>k :call EnqfL('5')<cr>:cprevious<cr>

nnoremap <silent> <leader>sv :source $HOME/.vimrc<cr>
nnoremap <silent> <leader>g :execute ':grep  <C-R><C-W> ' . expand('%:p:h')  <cr>


nmap <leader>f :CtrlP<CR><C-\>w
nnoremap <leader>l :call ClearMarksAndSearchs()<cr>

" vmap <leader>lf y:CtrlP<CR><C-\>c
nnoremap <leader>a :pyf $HOME/.vim/python/clang-format.py<CR>
nnoremap <leader>af :.,$pyf $HOME/.vim/python/clang-format.py<CR>
" nnoremap <silent> <leader>a :Ack <C-R><C-W><CR>

" relative path open for robot framewor
nnoremap <silent> <Leader>o :execute  ':e ' . expand("%:h") . "/" . expand("<cWORD>")<cr>

" save read only file
command! W w !sudo tee % > /dev/null

"Fast search & replace
noremap "" :s:::g<Left><Left><Left>
noremap "} :%s:::g<Left><Left><Left>
noremap "? :%s///g<Left><Left><Left>

" Mapping of jumps
nnoremap ' `
nnoremap ` '

" This is avesome alows . on visula mode
vnoremap . :norm.<CR>
nnoremap [[ ?{<CR>w99[{
nnoremap ][ /}<CR>b99]}
nnoremap ]] j0[[%/{<CR>
nnoremap [] k$][%?}<CR>

" this allows pasting just after the yanked text
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

command! W :execute ':silent w !sudo tee % > /dev/null' | :edit!
command! Wq wqall
command! WQ wqall
command! Q qall

" jumps remeber remeber '' is great
noremap gI `.

" buffer switching
nnoremap <silent> <C-h> :bprevious<CR>
nnoremap <silent> <C-l> :bnext<CR>


" use arrows for something usefull
nnoremap <M-right> <C-W>>2
nnoremap <M-left>  <C-W><2
nnoremap <silent> <M-up>    <Esc>:resize +2 <CR>
nnoremap <silent> <M-down>  <Esc>:resize -2 <CR>

nnoremap <c-left>  :colder<cr>zvzz
nnoremap <c-right> :cnewer<cr>zvzz
nnoremap <c-up>    :cprev<cr>zvzz
nnoremap <c-down>  :cnext<cr>zvzz

" Select (charwise) the contents of the current line, excluding indentation.
" Great for pasting Python lines into REPLs.
nnoremap vv ^vg_
vnoremap q <c-c>
nnoremap Q <nop>


noremap <silent> <F2> :set ignorecase! noignorecase?<CR>
noremap <silent> <F3> :GitGutterToggle<CR>
noremap <silent> <F4> :call NumberInv()<CR>
noremap <silent> <F5> :call ColorColumn()<cr>
noremap <silent> <F6> :setlocal spell! spell?<CR>

noremap <silent> <F8> :call ToggleMarkSearch()<cr>
" noremap <silent> <F6> :silent set nocursorline! cursorline?<CR>
" copy by F7
vnoremap <silent> <F7> "+ygv"zy`>
cnoremap <C-V> <C-R>+
""paste (Shift-F7 to paste after normal cursor, Ctrl-F7 to paste over visual selection)
nnoremap <silent> <F7> "+gP
" nnoremap <silent> <S-F7> "+gp
inoremap <silent> <F7> <C-r><C-o>+
vnoremap <silent> <C-F7> "+zp`]
if !empty(&pastetoggle) | set pastetoggle=<F9> |endif
" set pastetoggle=<F9>


" replace paste or swap
" vnoremap rp "0p
"""""""""""""""""""""""""
" => ctrl-p plugin
"""""""""""""""""""""""""
set wildignore=*.o,*.so,*.dll,*.pyc
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn)$',
    \ 'file': '\v\.(exe|so|dll)$',
    \ }
" maybe use tab, note c-m is same as Enter
noremap <c-n> :CtrlPBuffer<cr>
" this searches from current working directory
let g:ctrlp_working_path_mode = 'rw'
" this makes it from current buffer file path
" let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_prompt_mappings = {
    \ 'PrtInsert("r\"")': ['<c-u>'],
    \ 'PrtInsert("w")': ['<c-[>'],
    \ }

""""""""""""""""""""""""""""""
" => Robot framework plugin detection
"""""""""""""""""""""""""""""""
let g:robot_syntax_for_txt=1

""""""""""""""""""""""""""""""
" => Alternate file plugin
"""""""""""""""""""""""""""""""
let g:alternateSearchPath = 'sfr:../source,sfr:../src,sfr:../include,sfr:../inc,sfr:../include/telegraph'

""""""""""""""""""""""""""""""
" => rainbow_parenthsis plugin
"""""""""""""""""""""""""""""""
" FIXME: under terminal 12 max colors make some parenthes difficult tosee
" FIXME: still blue is diffictult to display on black backroudn
let g:rbpt_max = 8
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['DarkYellow',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ['darkred',     'SeaGreen3'],
    \ ]
" dark red is bad

augroup RainbowsParentheses
    autocmd!
    au VimEnter * RainbowParenthesesToggle
    au Syntax * RainbowParenthesesLoadRound
    au Syntax * RainbowParenthesesLoadSquare
    au Syntax * RainbowParenthesesLoadBraces
    " This will break for loop for ( int i=0; i<4; i++) see >
    " au Syntax * RainbowParenthesesLoadChevrons
augroup END

""""""""""""""""""""""""""""""
" => xptemplate plugin
"""""""""""""""""""""""""""""""
let g:SuperTabMappingForward              = '<tab>'
let g:xptemplate_key                      = '<c-\>'
let g:xptemplate_bundle                   = 'cpp_autoimplem'
let g:xptemplate_brace_complete           = ''
" if nothing matched in xpt, try supertab
"let g:xptemplate_fallback                 = '<Plug>supertabKey'
"let g:xptemplate_brace_complete = '([{'
" xpt triggers only when you typed whole name of a snippet. Optional
"let g:xptemplate_minimal_prefix = 'full'
let g:xptemplate_vars                     = "BRloop=\n" . "&" . "SParg="
let g:xptemplate_contact_info             =
  \ "author=Krzysztof Kanas" . "&" .
  \ "email=krzysztof.kanas@__at__@gmail.com" . "&" 

let g:xptemplate_vars = exists('g:xptemplate_vars') ?
  \ g:xptemplate_vars . '&' . g:xptemplate_contact_info
  \ : g:xptemplate_contact_info

"""""""""""""""""""""""""
" =>  Syntatctic
"""""""""""""""""""""""""
let g:syntastic_check_on_open=1
let g:syntastic_auto_loc_list=2
let g:syntastic_always_populate_loc_list=1
let g:syntastic_cpp_compiler_options = '-std=c++0x'
" let g:syntastic_enable_signs=0
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

"let g:pyflakes_use_quickfix = 1
"autocmd FileType python set omnifunc=pythoncomplete#Complete


""""""""""""""""""""""""""""""
" => nfs go code plugin bulshit
"""""""""""""""""""""""""""""""
let g:gonfs_dir = $HOME . '/Projects/gocode/src/github.com/nsf/gocode/vim/'
if isdirectory(g:gonfs_dir)
  let &runtimepath .= ',' . g:gonfs_dir
  " gocode have to be in path etc
endif

""""""""""""""""""""""""""""""
" => java android settings
"""""""""""""""""""""""""""""""
let g:android_root = "/home/chris/Projects/ever-note/android-core"
let g:syntastic_java_javac_classpath =  g:android_root . "/sdk/platforms/android-10/android.jar"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Autocmds Makefiles autocmd, kernel makefiles etc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("autocmd")
  augroup vimscipt
    autocmd FileType vim setlocal tabstop=2 shiftwidth=2 softtabstop=2
  augroup END

  augroup plugin_commentary
    autocmd!
    autocmd FileType asm setlocal commentstring=;\ %s
    autocmd FileType c,cpp setlocal commentstring=//\ %s
    autocmd FileType sql setlocal commentstring=--\ %s
    autocmd FileType go setlocal commentstring=//\ %s
    autocmd FileType robot setlocal commentstring=Comment\ \ \ \ %s
    autocmd FileType cfg,fstab setlocal commentstring=#\ %s
    autocmd FileType gitconfig,gdb,tmux setlocal commentstring=#\ %s
    autocmd FileType *conf-d,*config setlocal commentstring=#\ %s
    autocmd BufEnter *.conf setlocal commentstring=#\ %s
    autocmd FileType gentoo-init-d,gentoo-package-use,gentoo-package-keywords setlocal commentstring=#\ %s
    autocmd FileType htmldjango setlocal commentstring={#\ %s\ #}
    autocmd FileType clojurescript setlocal commentstring=;\ %s
    autocmd FileType xdefaults setlocal commentstring=!\ %s
  augroup END

  augroup quickfix
    autocmd!
    autocmd BufReadPost quickfix  setlocal nornu number
    " autocmd BufReadPost quickfix set modifiable
    autocmd Syntax quickfix wincmd p
  augroup END

  augroup Build
    autocmd!
    autocmd BufEnter *  call SetMakePrg()
  augroup END

  augroup Makefile
    autocmd!
    autocmd BufEnter  ?akefile*	set iskeyword+=-
    autocmd BufLeave  ?akefile*	set iskeyword-=-
    autocmd BufEnter  *.mk	    set iskeyword+=-
    autocmd BufLeave  *.mk	set iskeyword-=-
  augroup END

  augroup CodeFormatters
      autocmd!
      " autocmd  Filetype gentoo-init-d setlocal
      " autocmd  BufReadPost,FileReadPost   *.py    :silent %!PythonTidy.py
      " autocmd  BufReadPost,FileReadPost   *.p[lm] :silent %!perltidy -q
      " autocmd  BufReadPost,FileReadPost   *.xml   :silent %!xmlpp -t -c -n
      " autocmd  BufReadPost,FileReadPost   *.[ch]  :silent %!indent
  augroup END

  augroup formating
    autocmd!
    autocmd BufEnter *.tex   setlocal textwidth=80
    autocmd FileType svn,gitcommit setlocal spell
    " disable autocomand for paste with comments
    " when pasting comments span across multiple lines
    autocmd FileType * setlocal formatoptions-=tcro
  augroup END

  augroup text-fixes
    autocmd!
    " autocmd InsertLeave  * call StripWhitespace()
    if version >= 702
      autocmd BufWinLeave * call clearmatches()
    endif
    au BufWinEnter * match ExtraWhitespace /\s\+$/
    au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    au InsertLeave * match ExtraWhitespace /\s\+$/
  augroup END

  augroup cpp
    autocmd!
    autocmd BufEnter  *.cpp,*.c,*.h,*.hpp	set completeopt-=preview
    autocmd BufLeave  *.cpp,*.c,*.h,*.hpp	set completeopt+=preview
    " autocmd BufEnter  *.cpp,*.c,*.h,*.hpp	set iskeyword+=:
    " autocmd BufLeave  *.cpp,*.c,*.h,*.hpp	set iskeyword-=:
  augroup END

endif
""""""""""""""""""""""""""""""""""""""""""
" =>  xml
""""""""""""""""""""""""""""""""""""""""""
" This should strighten out the xml
" TODO dude you have to check the clam plugin
function! s:XmlFormat() range " {{{
  let old_z = @z
  let old_paste = &paste

  normal! gv"zy
  let result = system('xmllint --format -',@z)
  silent! execute a:firstline . ',' a:lastline . 'd'
  set paste
  execute 'normal I' . result

  let &paste = old_paste
  let @z = old_z
endfunction " }}}

command! -range=%  -nargs=0 XmlFormat call s:XmlFormat()

""""""""""""""""""""""""""""""""""""""""""
" =>  GitGutter
""""""""""""""""""""""""""""""""""""""""""
hi SignColumn ctermbg=NONE

nnoremap <silent> tr :GitGutterPrevHunk<cr>
nnoremap <silent> tu :GitGutterNextHunk<cr>

""""""""""""""""""""""""""""""""""""""""""
" =>  abbreviation to the spelling rescue
""""""""""""""""""""""""""""""""""""""""""
iabbrev <expr> dts strftime("%c")
" debian changelog timestamp
iabbrev <expr> dch strftime("%a, %d %b %Y %H:%M:%S %z")
" spelling
iabbrev prevous previous
iabbrev prefxi prefix

iabbrev neccesary necessary
iabbrev acction action
iabbrev destyni destiny
iabbrev specyfiyng specifying
iabbrev soruce source
iabbrev veryfy verify
iabbrev veryfi verify
iabbrev vecotr vector

iabbrev timedout timed out
iabbrev timeouted timed out
iabbrev readed  read
iabbrev sended send
iabbrev succesfull  successful


" imap <C-I> <ESC>:pyf $HOME/.vim/python/clang-format.py<CR>i
"""""""""""""""""""""""""
" => Some Notes that I keep forgeting
"""""""""""""""""""""""""
":AlignCtrl W :<,>Align     Align some text not mater white spaces/words in front and in back
