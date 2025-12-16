typeset -U path PATH
path=(
  /opt/homebrew/bin(N-/)
  /opt/homebrew/sbin(N-/)
  /usr/local/bin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  /opt/homebrew/bin(N-/)
  /opt/homebrew/sbin(N-/)
  /Library/Apple/usr/bin(N-/)
)

add_newline() {
  if [[ -z $PS1_NEWLINE_LOGIN ]]; then
    PS1_NEWLINE_LOGIN=true
  else
    printf '\n'
  fi
}
precmd() { add_newline }

# alias:1
alias h="history | grep --color=auto"

# alias:2
alias wk="cd works |ls -FG"
# alias ls="ls -FG"
alias ls="eza"
alias ll="eza --icons -al --group-directories-first"
alias tree="eza --icons -al -T -L 2"
alias dc="docker compose"
# alias vi="nvim"

# python3
alias py='python3'
alias python='python3'

# git
alias ga='git add'
alias gd='git diff'
alias gs='git status'
alias gp='git push'
alias gb='git branch'
alias gco='git checkout'
alias gf='git fetch'
alias gc='git commit'
alias lg='lazygit'

# global コマンドの途中でも展開される
alias -g A="| awk"
alias -g G="| grep --color=auto"
alias -g H="| head"
alias -g T="| tail"

# 初回シェル時のみ tmux実行
# if [ $SHLVL = 1 ]; then
#   tmux
# fi

# =======================================================
# fzf (fuzzy finder) key-bindings setting
# macOS (Homebrew) および Linux 環境に対応
# =======================================================
# fzfのキーバインド設定を読み込む
# 様々な環境に対応するため、複数の候補パスを試す
_fzf_key_bindings_locations=(
  '/usr/share/doc/fzf/examples/key-bindings.zsh' # Debian/Ubuntu/RHEL
  '/usr/share/fzf/key-bindings.zsh'             # Other Linux
  "$HOME/.fzf/shell/key-bindings.zsh"           # fzf installed from git repository
)

# macOS (Homebrew)環境の場合、Homebrewでインストールされたfzfのパスを最優先する
if command -v brew &>/dev/null; then
  _fzf_key_bindings_locations=($(brew --prefix)/opt/fzf/shell/key-bindings.zsh "${_fzf_key_bindings_locations[@]}")
fi

# 存在するキーバインドファイルを一つだけ読み込む
for _fzf_file in "${_fzf_key_bindings_locations[@]}"; do
  if [[ -f "$_fzf_file" ]]; then
    source "$_fzf_file"
    break
  fi
done
unset _fzf_key_bindings_locations _fzf_file

# =======================================================
# nvm (Node Version Manager) setting
# macOS (Homebrew) および Linux 環境に対応
# =======================================================
export NVM_DIR="$HOME/.nvm"

# macOS (Homebrew)のnvmを読み込む
if command -v brew &>/dev/null; then
  nvm_prefix="$(brew --prefix)/opt/nvm"
  # nvm.shの読み込み
  if [ -s "$nvm_prefix/nvm.sh" ]; then
    . "$nvm_prefix/nvm.sh"  # This loads nvm
  fi
  # nvm bash_completionの読み込み
  if [ -s "$nvm_prefix/etc/bash_completion.d/nvm" ]; then
    . "$nvm_prefix/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
  fi
# Linux や Homebrew 以外の環境 (標準インストール)
elif [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"  # This loads nvm
  # bash_completion を読み込む
  if [ -s "$NVM_DIR/bash_completion" ]; then
    . "$NVM_DIR/bash_completion"
  fi
fi

