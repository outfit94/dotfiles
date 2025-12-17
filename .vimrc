" =======================================================
" .vimrc - Full Integrated Version (Mac/Linux)
" =======================================================
scriptencoding utf-8
filetype plugin indent on
set fenc=utf-8

" 1. プラグイン管理 (vim-plug) の自動セットアップ
let s:plug_dir = expand('~/.vim/autoload/plug.vim')
if !filereadable(s:plug_dir)
  echo "Installing vim-plug..."
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'haya14busa/vim-edgemotion'
Plug 'Lokaltog/vim-easymotion'
Plug 'simeji/winresizer'
call plug#end()

" 2. 検索・表示・編集の基本設定
set ignorecase smartcase wrapscan incsearch hlsearch
set foldmethod=indent
set autoindent smartindent
set backspace=indent,eol,start
set wildmenu wildmode=list:longest
set formatoptions+=mM
set autoread hidden
vnoremap p "_dP

set nrformats=
set whichwrap=b,s,h,l,<,>,[,],~
set mouse=a noerrorbells
set number ruler
set nolist nofoldenable
set expandtab tabstop=2 shiftwidth=2 softtabstop=2
set nowrap laststatus=2
set cmdheight=2 showcmd title
set cursorline
set virtualedit=block
set ambiwidth=double
set showmatch matchtime=1 display=lastline
set listchars=tab:^\ ,trail:~
hi Comment ctermfg=3

set nobackup noswapfile noundofile

" 3. OS 判定とクリップボード設定
let s:is_mac = has('mac') || has('macunix')
if has("clipboard")
  set clipboard=unnamed,unnamedplus
endif

" 4. キーマッピング (Leader = Space)
let mapleader = "\<Space>"

nnoremap <Leader>jj <Esc>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Esc><Esc> :nohlsearch<CR><ESC>

noremap <Leader>a myggVG$
nnoremap <Leader>a <Esc>myggVG$

nnoremap <Leader><Leader> <C-w>w
nnoremap <Left> <C-w>h
nnoremap <Down> <C-w>j
nnoremap <Up> <C-w>k
nnoremap <Right> <C-w>l

nnoremap <silent> <Leader>. :new $MYVIMRC<CR>
nnoremap <silent> <Leader>, :source $MYVIMRC<CR>
nnoremap <Leader>re :%s;\<<C-R><C-W>\>;g<Left><Left>;

" 5. Netrw 設定
let g:netrw_liststyle=1
let g:netrw_banner=1
let g:netrw_sizestyle="H"
let g:netrw_preview=1
let g:netrw_altv=1
let g:netrw_alto=1

" 6. タブページ表示・移動のカスタマイズ
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

function! s:my_tabline()
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = '[' . fnamemodify(bufname(bufnr), ':t') . ']'
    let s .= '%'.i.'T%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= i . ':' . title . mod . '%#TabLineFill# '
  endfor
  return s . '%#TabLineFill#%T%=%#TabLine#'
endfunction

let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2

nmap t [Tag]
nnoremap [Tag] <Nop>
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
map <silent> [Tag]c :tablast <bar> tabnew<CR>
map <silent> [Tag]x :tabclose<CR>
map <silent> [Tag]n :tabnext<CR>
map <silent> [Tag]p :tabprevious<CR>

" 挿入モード時の色変更
let g:hi_insert = 'highlight TabLineSel guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'
if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:TabLineSel('Enter')
    autocmd InsertLeave * call s:TabLineSel('Leave')
  augroup END
endif
function! s:TabLineSel(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('TabLineSel')
    silent exec g:hi_insert
  else
    highlight clear TabLineSel
    silent exec s:slhlcmd
  endif
endfunction
function! s:GetHighlight(hi)
  redir => hl | exec 'highlight '.a:hi | redir END
  return substitute(substitute(hl, '[\r\n]', '', 'g'), 'xxx', '', '')
endfunction

" 7. 各種関数
map <leader>n :call RenameCurrentFile()<cr>
function! RenameCurrentFile()
  let old = expand('%')
  let new = input('新規ファイル名: ', old , 'file')
  if new != '' && new != old
    exec ':saveas ' . new
    call delete(old)
    redraw!
    echo "Renamed: " . old . " -> " . new
  endif
endfunction

command! -nargs=? -complete=dir -bang CD  call s:ChangeCurrentDir('<args>', '<bang>')
function! s:ChangeCurrentDir(directory, bang)
  if a:directory == '' | lcd %:p:h | else | execute 'lcd' . a:directory | endif
  if a:bang == '' | pwd | endif
endfunction
nnoremap <silent> <Space>cd :<C-u>CD<CR>

" NERDTree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>

" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" edgemotion
map <C-j> <Plug>(edgemotion-j)
map <C-k> <Plug>(edgemotion-k)

" easymotion
let g:EasyMotion_do_mapping = 0 "Disable default mappings
nmap s <Plug>(easymotion-s2)
