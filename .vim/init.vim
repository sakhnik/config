" vim: set noet ts=2 sw=2:

if &term == "linux"
	set t_ve+=[?81;0;112c
endif

if has('nvim')
	runtime! python_setup.vim
endif

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

set fileencodings=ucs-bom,utf-8,cp1251,default
set nocompatible
set nobackup backupdir=.
set wildmode=longest,list

if has("autocmd")

	augroup vimrcEx
		au!

		" For all text files set 'textwidth' to 78 characters.
		autocmd FileType text setlocal textwidth=78 lbr
		autocmd FileType gitcommit setlocal spell
	augroup END

	augroup misc
		au!

		" When editing a file, always jump to the last known cursor position.
		" Don't do it when the position is invalid or when inside an event handler
		" (happens when dropping a file on gvim).
		autocmd BufReadPost *
		    \ if line("'\"") > 0 && line("'\"") <= line("$") |
		    \   exe "normal g`\"" |
		    \ endif

		" Don't preserve a buffer when reading from stdin
		" This is useful for "svn diff | vim -"
		autocmd StdinReadPost * setlocal buftype=nofile

		" Autoclose preview window (omni completion) when leaving insert mode
		autocmd InsertLeave * if pumvisible() == 0|silent! pclose|endif
	augroup END

	augroup reload_vimrc
		au!
		autocmd bufwritepost $MYVIMRC source $MYVIMRC
	augroup END

	" TODO: Substitute with UltiSnips
	augroup templates
		au!
		" Read source file skeletons
		autocmd BufNewFile *.*  silent! execute '0r $HOME/.vim/templates/skeleton.'.expand("<afile>:e")

		" Substitute everything between [:VIM_EVAL:] and [:END_EVAL:]
		" with the result of expression in it
		autocmd BufNewFile *    %substitute#\[:VIM_EVAL:\]\(.\{-\}\)\[:END_EVAL:\]#\=eval(submatch(1))#ge
	augroup END

	" Set custom options for specific files
	augroup custom_options
		au!
		" Read source file skeletons
		autocmd BufReadPost /tmp/evo*  setlocal ft=text tw=72 spell
		autocmd BufReadPost /tmp/itsalltext/jira2*.txt setlocal tw=0 spell
	augroup END

endif " has("autocmd")

set ignorecase smartcase
set tabstop=4
set cindent shiftwidth=4
set cinoptions=:0,=1s,g0,(0,M1,U0,u0

" In many terminal emulators the mouse works just fine, thus enable it.
if exists("+mouse")
	set mouse=a
endif

set guioptions-=T
set guioptions-=m
set mousehide
set clipboard=unnamed
set completeopt=menu,longest,preview
set shortmess=a
let mapleader=' '
let maplocalleader=' '
set cmdheight=2

nnoremap <leader>w :w<cr>
nnoremap <leader>uu :GundoToggle<cr>

nnoremap & :&&<cr>
xnoremap & :&&<cr>

nmap <C-l> :redraw!<cr>

" Expand %% to the directory of the current buffer
cnoremap <expr> %%  getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

nnoremap <leader>ve :split $MYVIMRC<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Alternate
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:alternateExtensions_cc = "hh,h,hpp"
let g:alternateExtensions_hh = "cc"
let g:alternateExtensions_hxx = "cxx"
let g:alternateExtensions_cxx = "hxx,h"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Airline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_theme='dark'
let g:airline_left_sep = ''
let g:airline_right_sep = ''
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_symbols.branch = '⎇ '   "±
let g:airline_symbols.paste = 'ρ'
"let g:airline_symbols.linenr = '¶ '

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => CtrlP
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ctrlp_extensions = ['tag']
let g:ctrlp_show_hidden = 1
let g:ctrlp_use_caching = 0
let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/](\.git|\CBUILD[-_a-z0-9]*|sstate-cache|downloads|buildhistory|build[-_a-zA-Z]*)$'
	\ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => YouCompleteMe
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ycm_global_ycm_extra_conf = $HOME . '/.vim/ycm_extra_conf.py'
let g:ycm_filetype_blacklist = {
	\ 'notes' : 1,
	\ 'markdown' : 1,
	\ 'text' : 1,
	\ 'conque_term' : 1,
	\}
let g:ycm_confirm_extra_conf = 0
let g:ycm_collect_identifiers_from_tags_files = 1 " Let YCM read tags from Ctags file
let g:ycm_use_ultisnips_completer = 1 " Default 1, just ensure
let g:ycm_seed_identifiers_with_syntax = 1 " Completion for programming language's keyword
let g:ycm_complete_in_comments = 1 " Completion in comments
let g:ycm_complete_in_strings = 1 " Completion in string

nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => ConqueTerm
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ConqueTerm_StartMessages = 0
let g:ConqueTerm_SendVisKey = '<leader>cc'

runtime! plugin/*.vim

runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()

set novb t_vb=    " Не бікати взагалі ніколи
"set t_ti= t_te=   " Не очищувати екран після виходу
set keymap=uk     " Завантажити українську мапу клавіш
set iminsert=0    " Встановити англійську (i_ctrl-^)
set imsearch=0
set showbreak=\\  "↪
set modeline
if has('persistent_undo')
	set undofile
	set undodir=/tmp/vim_undo-$USER
	if !isdirectory(&undodir)
		if exists("*mkdir")
			call mkdir(&undodir, "p", 0700)
		else
			set undodir=.
		endif
	endif
endif
" Forget about ex mode
map Q <nop>
" Don't use Ex mode, use Q for formatting
"map Q gq

" Find tailing white spaces
nnoremap <Leader><space> /\s\+$\\| \+\ze\t<cr>

" Doxygen parser
let &efm = &efm . ',%f:%l\ %m'

" Ignore timestamp lines in Google Test output
let gtest_efm = '%E%f:%l:\ Failure'
let gtest_efm .= ',%Z%m'
let &efm = gtest_efm . ',' . &efm
let glib_efm = '%[%^:]%#:%[A-Z]%#:%f:%l:%m'
let &efm = glib_efm . ',' . &efm

" CMake Parser
" Call stack entries
let &efm .= ', %#%f:%l %#(%m)'
" Start of multi-line error
let &efm .= ',%E' . 'CMake Error at %f:%l (message):'
" End of multi-line error
let &efm .= ',%Z' . 'Call Stack (most recent call first):'
" Continuation is message
let &efm .= ',%C' . ' %m'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ultisnips
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Trigger configuration.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 2  "Close location list automatically
let g:syntastic_aggregate_errors = 1
let g:syntastic_html_tidy_exec = 'tidy5'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Incsearch
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

map z/ <Plug>(incsearch-fuzzy-/)
map z? <Plug>(incsearch-fuzzy-?)
map zg/ <Plug>(incsearch-fuzzy-stay)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if &t_Co > 2 || has("gui_running")
	let g:CSApprox_attr_map = { 'bold' : 'bold', 'italic' : 'italic', 'sp' : 'fg' }
	if has("autocmd")
		augroup colors
			au!
			autocmd ColorScheme * hi Comment cterm=italic
		augroup END
	endif
	colors zenburn
	hi Comment cterm=italic
endif

"vim: set noet ts=4 sw=4: