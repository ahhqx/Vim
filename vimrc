" Get out of VI's compatible mode..
set nocompatible

if v:version < 700
    echoerr 'This vimrc requires Vim 7 or later.'
    finish
endif

if has("win32")
    let $VIMFILES = $VIM.'/vimfiles'
else
    let $VIMFILES = $HOME.'/.vim'
endif
let $VIMRC = $VIMFILES.'/vimrc'

"---------------"
"	UI Setting	"
"---------------"
	
" Enable filetype plugin
filetype plugin indent on
" Set mapleader 
let mapleader = ","
let g:mapleader = ","
" Set 7 lines to the curors - when moving vertical..
set so=7
" Turn on WiLd menu
set wildmenu
set wildmode=longest,full
set wildignore=*.bak,*.o,*.e,*~,*.pyc,*.svn
" Always show current position
set ruler
" The commandbar is 2 high
""set cmdheight=2
" Show line number
set number
" Set backspace
set backspace=eol,start,indent
" Bbackspace and cursor keys wrap to
set whichwrap+=<,>,h,l
"Ignore case when searching
set ignorecase
set incsearch
" Set magic on
set magic
" Highlight search things
set hlsearch
" Have the mouse enabled all the time:
set mouse=a
" show incomplete commands
set showcmd 
" Sets how many lines of history VIM har to remember
set history=800
" Always switch to the current file directory
set autochdir  
"Set the terminal title
set title

" Turn backup off
set nobackup
set nowb
set noswapfile

" Set to auto read when a file is changed from the outside
set autoread

" Folding settings
set nofoldenable        "dont fold by default
set foldmarker={,}
set foldopen=block,hor,mark,percent,quickfix,tag
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set foldlevel=1         "this is just what i use
map <leader>f1 :set fdm=manual<cr>
map <leader>f2 :set fdm=indent<cr>
map <leader>f3 :set fdm=marker<cr>

" Text options
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set smarttab
set linebreak
set textwidth=500
set isfname-=\= " fix filename completion in VAR=/path
set autoindent
set smartindent

" display shorthand commands, Don't display start text :help iccf
set shortmess=atI 

"---------------"
"	Shortcuts	"
"---------------"

" Select Allne      
map <leader>a ggVG
" Switch to current dir, see also :set autochdir
map <leader>cd :cd %:p:h<cr>
" Temp text buffer
map <leader>e :e ~/.buffer<cr>
" Remove the Windows ^M
map <leader>M :%s/\r//g<cr> 
" Fast Quit
map <leader>q :q<cr>
" Fast reloading of the .vimrc
map <leader>es :e $VIMRC<cr>
map <leader>s :source $VIMRC<cr>
" 自动载入VIM配置文件
autocmd! bufwritepost vimrc source $MYVIMRC

" Undolist
map <leader>u :undolist<cr>
" Undo
inoremap <C-z> <C-O>u
" Fast saving
map <leader>w :w!<cr>
map <C-S> <Esc>:w!<cr>
" display file path
map <leader>file :echo expand("%:p")<cr>


" Bash like
imap <C-A> <Home>
imap <C-E> <End>
imap <C-K> <Esc>d$i
imap <C-B> <Left> 
imap <C-F> <Right> 

" Command-line
"cnoremap <C-A> <Home>
"cnoremap <C-E> <End>
"cnoremap <C-B> <Left>
"cnoremap <C-F> <Right>

" Usefull when insert a new indent line
imap fj <cr><C-O>O
" Remove tag content see :help object-select
imap jf <C-O>cit

" Super paste
inoremap <C-v> <esc>:set paste<cr>mui<C-R>+<esc>mv'uV'v=:set nopaste<cr>

" Some nice mapping to switch syntax (useful if one mixes different languages in one file)
map <leader>1 :set syntax=xhtml<cr>
map <leader>2 :set ft=css<cr>
map <leader>3 :set ft=javascript<cr>
map <leader>$ :syntax sync fromstart<cr>

map <Tab> <C-w><C-w>
map <F1> :NERDTreeToggle<CR>
map <F2> :tabprevious<CR>
map <F3> :tabnext<CR>
map <F4> :vsplit<CR>
map <F5> :! open -a Firefox.app %<cr><esc>
map <C-k> :tabclose<CR>
map <C-F4> :tabclose<CR>
map <F7> :call ToggleColor()<CR>
map <F9> :!svn update<CR>
map <F10> :!svn commit --message=''<LEFT>
map <F11> :call ToggleWrapping()<CR>

" use Alt-n to switch tab
for i in range(1, min([&tabpagemax, 9]))
    execute 'nmap <A-'.i.'> '.i.'gt'
endfor

map Q :exit<CR>

let g:user_zen_expandabbr_key = '<D-e>'



"---------------"
"moving and tab	"
"---------------"

" Actually, the tab does not switch buffers, but my arrows
" Use the arrows to something usefull
nmap <C-P> :bp<cr>
nmap <C-N> :bn<cr>
map <C-E> :Bclose<cr>

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()

function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

""""""""""""""""""""""""""""""
" => Statusline
""""""""""""""""""""""""""""""
" Always hide the statusline
set laststatus=2

""""""""""""""""""""""""""""""
" => Visual
""""""""""""""""""""""""""""""
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"
    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")
    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    else
        execute "normal /" . l:pattern . "^M"
    endif
    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Basically you press * or # to search for the current selection !! Really useful
vnoremap <silent> * :call VisualSearch('f')<cr>
vnoremap <silent> # :call VisualSearch('b')<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Parenthesis/bracket expanding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Map auto complete of (, ", ', [,{
inoremap ( ()<esc>:let leavechar=")"<cr>i
inoremap [ []<esc>:let leavechar="]"<cr>i
inoremap { {}<esc>:let leavechar="}"<cr>i
inoremap < <><esc>:let leavechar=">"<cr>i
"inoremap ' ''<esc>:let leavechar="'"<cr>i
"inoremap " ""<esc>:let leavechar='"'<cr>i
inoremap )) (<esc>o)<esc>:let leavechar=")"<cr>O
inoremap ]] [<esc>o]<esc>:let leavechar="]"<cr>O
inoremap }} {<esc>o}<esc>:let leavechar="}"<cr>O

vnoremap #( <esc>`>a)<esc>`<i(<esc>
vnoremap #[ <esc>`>a]<esc>`<i[<esc>
vnoremap #{ <esc>`>a}<esc>`<i{<esc>
vnoremap #< <esc>`>a><esc>`<i<<esc>
vnoremap #' <esc>`>a'<esc>`<i'<esc>
vnoremap #" <esc>`>a"<esc>`<i"<esc>

"---------------"
"    plugin     "
"---------------"

" NERD_tree.vim
map <F8> :NERDTreeToggle<CR>
map <leader>f ::NERDTreeFind<CR>
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeChDirMode = 2
let NERDTreeIgnore=['\.pyc$','\.svn$','\.tmp$','\.bak','\~$']

" closetag.vim
let g:closetag_html_style=1

" acp.vim & SnipMate.vim
let g:acp_behaviorSnipmateLength =1
let g:acp_enableAtStartup = 1
let g:acp_completeOption = '.,w,b,u,t,i,k'

" JSLint.vim
if has("win32")
    let g:jslint_command = $VIMFILES . '/extra/jslint/jsl.exe'
else 
    let g:jslint_command = $VIMFILES . '/extra/jslint/jsl'
endif
let g:jslint_command_options = '-conf ' .  $VIMFILES . '/extra/jslint/jsl.conf -nofilelisting -nocontext -nosummary -nologo -process'
map <leader>j :call JavascriptLint()<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Set OminComplete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set completeopt=longest,menu
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags 
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors & Fonts & Syntax
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax
syntax enable

if has("gui_running")
    colorscheme molokai
    " Highlight current
    set cursorline
    " Toggle Menu and Toolbar and switch fullscreen mode
    set guioptions-=b " Hide bottom scrollbar
    set guioptions-=l " Hide left scrollbar
    set guioptions-=L
    set guioptions-=m " Hide Menu
    set guioptions-=T " Hide Toolbar
    map <silent> <F11> :if &guioptions =~# 'm' <Bar>
                \set guioptions-=m <bar>
                \else <Bar>
                \set guioptions+=m <Bar>
                \endif<cr>
    " Auto Maximize when vim starts.
    if has("win32")
        au GUIEnter * simalt ~x
    elseif has("unix")
        au GUIEnter * winpos 0 0
        "set lines=999 columns=9999
    endif

    " Omni menu colors
    hi Pmenu guibg=#333333
    hi PmenuSel guibg=#555555 guifg=#ffffff

    " Turn undofile on
    set undofile
    " Set undofile path
    set undodir=~/tmp/vim/undofile/

    " 关闭VIM的时候保存会话，按F6读取会话
    set sessionoptions=buffers,sesdir,help,tabpages,winsize
    au VimLeave * mks! ~/.Session.vim
    nmap <F6> :so ~/.Session.vim<CR>

else
    set background=dark
    colorscheme kellys
endif

if has("gui_macvim")
    set transparency=1
    " 开启抗锯齿渲染
    set anti
endif

"equal width/height when split window
set equalalways

if has("statusline")
	set laststatus=2
	set statusline=\ %F%m%r%h%y[%{&fileformat},\ %{&fileencoding}%{((exists(\"+bomb\")\ &&\ &bomb)?\"+\":\"\")}]\ %w%=(%b,0x%B)\ (%l,%c)\ %P\ %{&wrap?'WR':'NW'}\ %{&ic?'IC':'CS'}\ 
endif

" global
set encoding=utf-8
set helplang=cn,en
set t_Co=256

" autocmd
if has("autocmd")

	" TextBrowser settings
	autocmd BufRead,BufNewFile *.txt setlocal filetype=txt
	autocmd BufRead,BufNewFile *.log setlocal filetype=apachelogs
	autocmd BufRead,BufNewFile *.vm setlocal filetype=html
	autocmd BufRead,BufNewFile *.css.vm setlocal filetype=css
	autocmd BufRead,BufNewFile *.js.vm setlocal filetype=javascript

	" set options for specified filetype
	autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType html,htm set omnifunc=htmlcomplete#CompleteTags
	autocmd FileType css set omnifunc=csscomplete#CompleteCSS

endif

" multi byte
if has("multi_byte")
	language messages en_US.utf-8

	setglobal fileencoding=utf-8
	set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5
	set formatoptions+=mm

	if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
		set ambiwidth=double
	endif
endif

function! ToggleWrapping()
	if &wrap == 1
		set nowrap
	else
		set wrap
	endif
endfunction

function! ToggleColor()
	let colors = ['molokai', 'ir_black', 'yytextmate']
	let current = (index(colors, g:colors_name) + 1) % len(colors)
	execute 'colorscheme ' . colors[current]
endfunction

 
fun! GetSnipsInCurrentScope() 
    let snips = {} 
    for scope in [bufnr('%')] + split(&ft, '\.') + ['_'] 
      call extend(snips, get(s:snippets, scope, {}), 'keep') 
      call extend(snips, get(s:multi_snips, scope, {}), 'keep') 
    endfor 
    return snips 
endf 
 
