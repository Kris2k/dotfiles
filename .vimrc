set nocompatible
" set binary
" set noeol
" set cpoptions+={
" setlocal fo+=aw for vim mutt
""""""""""""""""""""""""""""""
" => Pathogen plugin
"""""""""""""""""""""""""""""""
source ~/.vim/bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()
" add xpt templates personal folder to runtimepath
" let &runtimepath .=',~/.vim/personal'

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
""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""
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

set title
syntax enable
filetype plugin indent on

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
" set colorcolumn=80
let g:tex_flavor='latex'
" set list
" set listchars=tab:.-
"""""""""""""""""""""""""
" => Files backups are off
"""""""""""""""""""""""""
set nobackup         "do not create backup file
set nowritebackup    "no create backup when overwriting file
set noswapfile    " enabled to prevent double editing

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

set autoread    "auto read when a file is changed from outside
set hidden      "warn on exit with unsaved changes

" Set backspace config
set backspace=indent,eol,start
set whichwrap+=<,>,h,l
set linebreak

set ignorecase "Ignore case when searching
set smartcase

set laststatus=2         " commandline display and tab in cmdline
set wildchar=<Tab> wildmenu wildmode=list:longest,full

set clipboard+=unnamed "  yanks go to system clipboard too and back on Focus
autocmd FocusGained * let @z=@+

" match pairs for <> (default for (:) [:] )
set matchpairs+=<:>
" Set a shorter timeout
set timeoutlen=250
" Fast exit from insert mode
inoremap jk <Esc>
inoremap JK <Esc>
inoremap Jk <Esc>
inoremap jK <Esc>

" Wrapped lines goes down/up to next row, rather than next line in file.
"nnoremap j gj
"nnoremap k gk

""""""""""""""""""""""""""""""""""
" => Terminal/gui settings (gvim)
""""""""""""""""""""""""""""""""""
if !has("gui_running") && !has('win32') && !has('win64')
    set term=$TERM       " Make arrow and other keys work
endif

if  &term =~ "linux" || &term =~ "cons25"
  set term=$TERM
  colorscheme desert
elseif &term =~ "xterm" || has("gui_running")
  set t_Co=256
  colorscheme kchrisk
else
  colorscheme darkblue
endif


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

"Function that opens a file
" in split if there is file opened, diffenent that unnamed["No Name"]
" as only file if there is no other file
function! NiceOpen(fname)
    if len(bufname("%")) == 0
        exec("edit ". strtrans(a:fname))
    else
        exec("vsplit ". strtrans(a:fname))
    endi
endfunction

""""""""""""""""""""""""""""""
" => mapleader
"""""""""""""""""""""""""""""""
let mapleader="\<Space>"
let maplocalleader = "\\"

" FIXME: this hack works for gnu screen problems when invoked make
nnoremap <leader><leader> :make <cr>
" nnoremap <leader><leader> :Dispatch<cr>
nnoremap <silent> <leader>, :let @/=""<cr>
nnoremap <silent> <leader>w :w!<cr>
nnoremap <silent> <leader>ss :cscope reset<cr>
nnoremap <silent> <leader>a :Ack <C-R><C-W><CR>
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
nnoremap <silent> <leader>en :call NiceOpen("/home/chris/Projects/utils/git-dotfiles/notes-programing.txt")<cr>

" Quick fix list window
" nmap <silent> <leader>l :call ToggleList("Location List", 'l','5','no')<CR>
nmap <silent> <leader>q :call ToggleList("Quickfix List", 'c','5','no')<CR>

nnoremap <silent> <leader>sv :source $HOME/.vimrc<cr>
nnoremap <silent> <leader>g :execute ':grep  <C-R><C-W> ' . expand('%:p:h')  <cr>


nmap <leader>f :CtrlP<CR><C-\>w
" vmap <leader>lf y:CtrlP<CR><C-\>c
" nnoremap <leader>f :pyf $HOME/.vim/python/clang-format.py<CR>
nnoremap <leader>af :.,$pyf $HOME/.vim/python/clang-format.py<CR>

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

" Common typos and Minibuffer Explorer hack
command! W :w
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
nnoremap <M-up>    <Esc>:resize -2 <CR>
nnoremap <M-down>  <Esc>:resize +2 <CR>

nnoremap <c-left>  :colder<cr>zvzz
nnoremap <c-right> :cnewer<cr>zvzz
nnoremap <c-up>    :cprev<cr>zvzz
nnoremap <c-down>  :cnext<cr>zvzz

" Select (charwise) the contents of the current line, excluding indentation.
" Great for pasting Python lines into REPLs.
nnoremap vv ^vg_
vnoremap q <c-c>
nnoremap Q <nop>
""""""""""""""""""""""""""""""
" => Fn  Shortcuts and others
"""""""""""""""""""""""""""""""
function! NumberInv()
  if &relativenumber| set nornu number | return | endif
  if &number| set nonumber nornu | return
  else | set relativenumber | return | endif
endfunction

noremap <silent> <F2> :set ignorecase! noignorecase?<CR>
noremap <silent> <F3> :GitGutterToggle<CR>
noremap <silent> <F4> :call NumberInv()<CR>
noremap <silent> <F5> :setlocal spell! spell?<CR>
noremap <silent> <F6> :silent set nocursorline! cursorline?<CR>
" copy by F7
vnoremap <silent> <F7> "+ygv"zy`>
cnoremap <C-V> <C-R>+
""paste (Shift-F7 to paste after normal cursor, Ctrl-F7 to paste over visual selection)
nnoremap <silent> <F7> "+gP
" nnoremap <silent> <S-F7> "+gp
inoremap <silent> <F7> <C-r><C-o>+
vnoremap <silent> <C-F7> "+zp`]
set pastetoggle=<F9>




" replace paste or swap
vnoremap rp "0p
""""""""""""""""""""""""""""""
" => grep in vim
"""""""""""""""""""""""""""""""
" -I ignore binary files -Hn is for printing file name and line number
set grepprg=grep\ -Hn\ -I\ --exclude-dir='.svn'\ --exclude-dir='.git'\ --exclude-dir='po'\ --exclude='tags*'\ --exclude='cscope.*'\ --exclude='*.html'\ --exclude-dir='.waf-*'\ -r

""""""""""""""""""""""""""""""
" => Custom Commands
"""""""""""""""""""""""""""""""
" Strip end of lines  can be done autocomand
function! <SID>StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

command! Strip call <SID>StripTrailingWhitespace()

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
  \ "author=Krzysztof (Chris) Kanas" . "&" .
  \ "email=krzysztof.kanas@__at__@gmail.com" . "&" .
  \ "kelvatek_author=Krzysztof (Chris) Kanas" . "&" .
  \ "kelvatek_email=k.kanas@__at__@kelvatek.com&..."

let g:xptemplate_vars = exists('g:xptemplate_vars') ?
  \ g:xptemplate_vars . '&' . g:xptemplate_contact_info
  \ : g:xptemplate_contact_info

"""""""""""""""""""""""""
" => airline plugin
"""""""""""""""""""""""""
let g:airline_theme='powerlineish'
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_section_z='%3p%% : %l:%c/%L'
" buferline
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
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


function! SetMakePrg()
  if &ft == 'go'
    setlocal makeprg=go\ run\ %
  endif
  if filereadable('.projectLite.vim')
    return
  endif
  if filereadable('wscript')
    setlocal makeprg=./waf\ --alltests
    return 0
  endif
  if filereadable('bam.lua') && filereadable('./bam')
    setlocal makeprg='./bam'
    return
  endif
  if glob('?akefile') != ''
    setlocal makeprg=make\ -j4\ $*
    return 0
  endif
  if bufname("%") =~ ".*\.tex"
    setlocal makeprg=latexmk\ -pdf
    return 0
  endif

  if bufname("%") =~ ".*\.c$"
    setlocal makeprg=gcc\ -Wall\ -g\ -std=c99\ %
    return 0
  endif
  if  bufname("%") =~ ".*\.cpp"
    setlocal makeprg=g++\ -g\ -Wall\ -std=c++0x\ %
    return 0
  endif
  return 1
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Quickfix sort
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! g:CompareQuickfixEntries(i1, i2)
  if bufname(a:i1.bufnr) == bufname(a:i2.bufnr)
    return a:i1.lnum == a:i2.lnum ? 0 : (a:i1.lnum < a:i2.lnum ? -1 : 1)
  else
    return bufname(a:i1.bufnr) < bufname(a:i2.bufnr) ? -1 : 1
  endif
endfunction

function! g:SortUniqQFList()
  let sortedList = sort(getqflist(), 's:CompareQuickfixEntries')
  let uniqedList = []
  let last = ''
  for item in sortedList
    let this = bufname(item.bufnr) . "\t" . item.lnum
    " let this = bufname(item.bufnr)
    if this !=# last
      call add(uniqedList, item)
      let last = this
    endif
  endfor
  call setqflist(uniqedList)
endfunction
" this needs messue up the compliation
" autocmd! QuickfixCmdPost * call g:SortUniqQFList()

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
  augroup END

  augroup quickfix
    autocmd!
    autocmd BufReadPost quickfix  setlocal nornu number
    autocmd BufReadPost quickfix set modifiable
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
" convenience
cabbrev b buffer
cabbrev E Explore
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
