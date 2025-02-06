scriptencoding utf-8
filetype plugin on
set fenc=utf-8

"---------------------------------------------------------------------------
" 検索の挙動に関する設定:
"
" 検索時に大文字小文字を無視 (noignorecase:無視しない)
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase
" 検索時にファイルの最後まで行ったら最初に戻る
set wrapscan
" インクリメンタル検索 (検索ワードの最初の文字を入力した時点で検索が開始)
set incsearch
" 検索結果をハイライト表示
set hlsearch

"---------------------------------------------------------------------------
" 折りたたみ機能に関する設定:

" インデントで折りたたむ
set foldmethod=indent

"---------------------------------------------------------------------------
" 編集に関する設定:

" 自動的にインデントする
set autoindent
" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start
" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
set wildmenu
" コマンドラインの補完
set wildmode=list:longest
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" ビジュアルモードでペーストしたときにヤンクしない
vnoremap p "_dP

"---------------------------------------------------------------------------
" GUI固有ではない画面表示の設定:

" Windowsでパスの区切り文字をスラッシュで扱う
set shellslash
" シンタックスハイライト
syntax on
" すべての数を10進数として扱う
set nrformats=
" 行をまたいで移動
set whichwrap=b,s,h,l,<,>,[,],~
" バッファスクロール
set mouse=a
" エラーメッセージの表示時にビープを鳴らさない
set noerrorbells
" 行番号
set number
" ルーラーを表示 (noruler:非表示)
set ruler
" タブや改行を非表示 (list:表示)
set nolist
" 検索にマッチした行以外を折りたたむ(フォールドする)機能
set nofoldenable
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=2
" 行頭でのTab文字の表示幅
set shiftwidth=2
" タブキー押下時に挿入される文字幅を指定
set softtabstop=2
" 長い行を折り返さない
set nowrap
" 常にステータス行を表示 (詳細は:he laststatus)
set laststatus=2
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=2
" コマンドをステータス行に表示
set showcmd
" タイトルを表示
set title
" 画面を黒地に白にする
" colorscheme evening " (Windows用gvim使用時はgvimrcを編集すること)
" 現在の行を強調表示
set cursorline
hi clear CursorLine
" 現在の列を強調表示
" set cursorcolumn
" 矩形選択中は行末にテキストがなくてもカーソルを行末以降に移動
set virtualedit=block
" インデントはスマートインデント
set smartindent
" 全角文字専用の設定
set ambiwidth=double
" 対応する括弧やブレースを表示
set showmatch matchtime=1
" 省略されずに表示
set display=lastline
" 行末のスペースを可視化
set listchars=tab:^\ ,trail:~
" コメントの色を水色
hi Comment ctermfg=3
" 括弧入力時に対応する括弧を表示
set showmatch

"---------------------------------------------------------------------------
" ファイル操作に関する設定:

" バックアップファイルを作成しない
set nobackup
set noswapfile
set noundofile

" Escの2回押しでハイライト消去
nnoremap <Esc><Esc> :nohlsearch<CR><ESC>

" 他のアプリケーションとコピー＆ペーストできるようになるオプション
if has("clipboard")
  set clipboard=unnamed
endif

" 素早くウィンドウ移動
nnoremap <Left> <C-w>h
nnoremap <Down> <C-w>j
nnoremap <Up> <C-w>k
nnoremap <Right> <C-w>l

" Backspace キーを使う
" なおかつレジスタを汚さない
noremap <BS> "_xh

"---------------------------------------------------------------------------
" netrwに関する設定:
let g:netrw_liststyle=1
let g:netrw_banner=1
let g:netrw_sizestyle="H"
let g:netrw_timefmt="%Y/%m/%d(%a) %H:%M:%S"
let g:netrw_preview=1
" v でファイルを開くときは右側に開く
let g:netrw_altv=1
" o でファイルを開くときは下側に開く
let g:netrw_alto=1

"---------------------------------------------------------------------------
"タブページ表示・移動のカスタマイズ:

" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]

" Tab jump t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

" tc 新しいタブを一番右に作る
map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tx タブを閉じる
map <silent> [Tag]x :tabclose<CR>
" tn 次のタブ
map <silent> [Tag]n :tabnext<CR>
" tp 前のタブ
map <silent> [Tag]p :tabprevious<CR>

"---------------------------------------------------------------------------
"挿入モード時、アクティブタブの色を変更 TabLineSel:

let g:hi_insert = 'highlight TabLineSel guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:TabLineSel('Enter')
    autocmd InsertLeave * call s:TabLineSel('Leave')
  augroup END
endif

let s:slhlcmd = ''
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
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction

"---------------------------------------------------------------------------
" カレントディレクトリ移動のためのキーマップ:
command! -nargs=? -complete=dir -bang CD  call s:ChangeCurrentDir('<args>', '<bang>')
function! s:ChangeCurrentDir(directory, bang)
  if a:directory == ''
    lcd %:p:h
  else
    execute 'lcd' . a:directory
  endif
  if a:bang == ''
    pwd
  endif
endfunction

" Change current directory. [引数なし:ファイルの場所に移動][引数あり:引数の場所に移動][:CD!:移動先の明示]
nnoremap <silent> <Space>cd :<C-u>CD<CR>

"---------------------------------------------------------------------------
" leaderキー関連:
let mapleader = "\<Space>"

" 「Spaceキー + 各種キー」のようなキー操作マッピング
inoremap <Leader>jj <Esc>                         " ESCキー
nnoremap <Leader>w :w<CR>                         " 保存
nnoremap <Leader>q :q<CR>                         " 終了
noremap <Leader>a myggVG$                         " 全選択(ノーマル)
inoremap <Leader>a <Esc>myggVG$                   " 全選択(インサート)
nnoremap <silent> <Leader>. :new ~/.vimrc<CR>     " .vimrcを開く
nnoremap <silent> <Leader>, :source ~/.vimrc<CR>  " .vimrcの読み込み
noremap <Leader><Leader> <C-w>w                   " windowの移動
map <leader>n :call RenameFile()<cr>              " 編集中ファイルのリネーム

" リネーム関数定義
function! RenameCurrentFile()
  let old = expand('%')
  let new = input('新規ファイル名: ', old , 'file')
  if new != '' && new != old
    exec ':saveas ' . new
    exec ':silent !rm ' . old
    redraw!
  endif
endfunction

" カーソル下の単語を、置換後の文字列の入力を待つ状態にする
nnoremap <Leader>re :%s;\<<C-R><C-W>\>;g<Left><Left>;

"---------------------------------------------------------------------------
" プラグイン追加:
