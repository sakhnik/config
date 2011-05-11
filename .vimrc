set nocompatible
" Let's parse $VIMINIT, which is like "source path"
if $VIMINIT =~ 'source\s\+.*'
    let f1 = substitute($VIMINIT, 'source\s\+\(.*\)', '\1', "")
    let f2 = fnamemodify(f1, ":p:h").'/runtime'
    let &runtimepath=f2.','.$VIMRUNTIME
endif
let &termencoding=&encoding
if &term == "win32"
    set termencoding=cp866
elseif &termencoding == "koi8-r"
    set termencoding=koi8-u
endif
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp1251,default
runtime $VIMRUNTIME/vimrc_example.vim
if &term == "linux"
    set t_ve+=[?81;0;112c
endif

if v:progname =~? "evim"
    finish
endif

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

set nocompatible
set backspace=indent,eol,start
set nobackup
set history=50
set ruler
set noshowcmd
set incsearch
set wildmenu
set wildmode=longest,list,full
if has("win32")
    set shellpipe=2>&1\ \|\ tee
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

if has("autocmd")

    filetype plugin indent on

    augroup vimrcEx
        au!

        " For all text files set 'textwidth' to 78 characters.
        autocmd FileType text setlocal textwidth=78 lbr

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        autocmd BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \   exe "normal g`\"" |
                    \ endif

    augroup END

    " Don't preserve a buffer when reading from stdin
    " This is useful for "svn diff | vim -"
    autocmd StdinReadPost * setlocal buftype=nofile

    augroup templates
        au!
        " Read source file skeletons
        autocmd BufNewFile *.*  silent! execute '0r $HOME/.vim/templates/skeleton.'.expand("<afile>:e")
    augroup END

    " Substitute everything between [:VIM_EVAL:] and [:END_EVAL:]
    " with the result of expression in it
    autocmd BufNewFile *    %substitute#\[:VIM_EVAL:\]\(.\{-\}\)\[:END_EVAL:\]#\=eval(submatch(1))#ge
else

    set autoindent      " always set autoindenting on

endif " has("autocmd")

set expandtab
set tabstop=8
set cindent shiftwidth=4
set cinoptions=:0,=1s,g0,(1s,M1
if exists("+mouse")
    set mouse=a
endif
if has("gui_running")
    if has("gui_gtk2")
        set guifont=Monospace\ 14
    elseif has("x11")
    " Also for GTK 1
        set guifont=*-lucidatypewriter-medium-r-normal-*-*-180-*-*-m-*-*
    elseif has("gui_win32")
        set guifont=Courier_New:h12:cRUSSIAN
    endif
endif
set path+=../include
set listchars=tab:>-,trail:·,nbsp:%
set list
set guioptions-=T
set mousehide
set scrolloff=3
let Tlist_Inc_Winwidth=0
set statusline=%<%f\ %H%M%R%=%-7.k%-14.(%l,%c%V%)\ %P
set laststatus=2
set viminfo='100,f1,<500,h,s10
set clipboard=unnamed

nnoremap <f2> :confirm w<cr>
inoremap <f2> <c-o>:confirm w<cr>
nnoremap <f3> :cn<cr>
inoremap <f3> <c-o>:cn<cr>
nnoremap <s-f3> :cp<cr>
inoremap <s-f3> <c-o>:cp<cr>
nnoremap <f10> :confirm qa<cr>
inoremap <f10> <c-o>:confirm qa<cr>
nnoremap <c-f8> :FencView<cr>
inoremap <c-f8> <esc>:FencView<cr>

vnoremap * y/\V<C-R>=substitute(escape(@@,"/\\"),"\n","\\\\n","ge")<CR><CR>
vnoremap # y?\V<C-R>=substitute(escape(@@,"?\\"),"\n","\\\\n","ge")<CR><CR>
nnoremap <Leader>; :<c-u>ls!<Bar>sleep <c-r>=v:count1<cr><cr><cr>
vnoremap <Leader>/ <esc>/\%V
vnoremap <Leader>? <esc>?\%V

if exists(":vnew") && exists(":diffthis")
    function! s:DiffWithSaved()
        let filetype=&ft
        diffthis
        vnew | r # | normal 1Gdd
        diffthis
        exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
    endfunction
    com! Diff call s:DiffWithSaved() 
endif

if exists('+shellslash')
    set shellslash
endif

if exists(":colors")
    colors incognito
endif

" MRU plugin settings
let MRU_File = $HOME.'/.vim_mru_files'
let MRU_Max_Entries = 20
"       let MRU_Exclude_Files = '^/tmp/.*\|^/var/tmp/.*'  " For Unix
"       let MRU_Exclude_Files = '^c:\\temp\\.*'           " For MS-Windows
"       let MRU_Window_Height = 15
"       let MRU_Use_Current_Window = 1
let MRU_Auto_Close = 1

" CTRL-Tab is Next window
noremap <C-Tab> <C-W>w
inoremap <C-Tab> <C-O><C-W>w
cnoremap <C-Tab> <C-C><C-W>w
onoremap <C-Tab> <C-C><C-W>w

" SelectBuf shortcut
nmap <unique> <silent> <f4> <Plug>SelectBuf
imap <unique> <silent> <f4> <esc><Plug>SelectBuf

" headers shouldn't be ignored!
let g:netrw_sort_sequence='[\/]$,*,\.bak$,\.o$,\.info$,\.swp$,\.obj$'

let b:match_words = '\s*#\s*region.*$:\s*#\s*endregion'

noremap <silent> <f11> :call VimCommanderToggle()<cr>
inoremap <silent> <f11> <esc>:call VimCommanderToggle()<cr>
noremap <silent> <c-f11> :call VimCommanderToggle()<cr>
inoremap <silent> <c-f11> <esc>:call VimCommanderToggle()<cr>

let g:alternateExtensions_cc = "hh,h,hpp"
let g:alternateExtensions_hh = "cc,cpp,C"

let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_ViewRule_pdf = 'evince'
let g:Tex_ViewRule_dvi = 'evince'
let g:Tex_SmartKeyBS = 0
let g:Tex_SmartKeyQuote = 0
let g:Tex_SmartKeyDot = 0

runtime! plugin/*.vim
runtime ftplugin/man.vim

"if filereadable("Jamfile") || filereadable("Jamroot")
"    set makeprg=bjam
"endif

if has("autocmd")
    " Переносити довгі рядки у текстових файлах по словах
    autocmd BufRead *\.txt* setlocal lbr
    " More convenient man navigation
    autocmd FileType man
        \ nnoremap <buffer> <space> <c-f> |
        \ nnoremap <buffer> <bs> <c-b> |
        \ nnoremap <buffer> q ZQ
endif

" Viki settings
let g:vikiNameSuffix=".viki"
let g:vikiNameTypes="sSeuixwf"
if has("autocmd")
    autocmd! BufRead,BufNewFile *.viki setlocal filetype=viki foldlevel=99
endif

let g:EclimSgmlCompleteEndTag=0

let OmniCpp_MayCompleteDot = 0
let OmniCpp_MayCompleteArrow = 0
let OmniCpp_MayCompleteScope = 0

set tags=tags;/
let kernel_ver=system('uname -r')
let kernel_ver=substitute(kernel_ver, '\n$', '', '')
let kernel_tags='/lib/modules/' . kernel_ver . '/build/tags'
if filereadable(kernel_tags)
    let &tags .= ',' . kernel_tags
endif

if isdirectory($HOME.'/.tags')
    let tagfiles = globpath('~/.tags', '*.tags')
    if !empty(&tags)
        let &tags .= ','
    endif
    let &tags .= substitute(tagfiles, "\n", ",", "g")
endif

set vb t_vb=      " Не бікати взагалі ніколи
set keymap=uk     " Завантажити українську мапу клавіш
set iminsert=0    " Встановити англійську (i_ctrl-^)
set imsearch=0
set showbreak=>
set modeline
if has('persistent_undo')
    set undofile
    set undodir=/tmp/vim_undo
    if exists("*mkdir") && !isdirectory(&undodir)
        call mkdir(&undodir,"p")
    endif
endif

"let $PAGER=''
