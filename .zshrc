# =======================================================
# OS 判定
# =======================================================
case ${OSTYPE} in
    darwin*)  OS='Mac' ;;
    linux*)   OS='Linux' ;;
esac

# =======================================================
# Path 設定
# =======================================================
typeset -U path PATH
path=(
  /opt/homebrew/bin(N-/)    # Mac (Apple Silicon)
  /opt/homebrew/sbin(N-/)   # Mac (Apple Silicon)
  /home/linuxbrew/.linuxbrew/bin(N-/) # Linux (Homebrew)
  $HOME/.local/bin(N-/)
  /usr/local/bin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  /Library/Apple/usr/bin(N-/)
) 

# =======================================================
# UI / Prompt
# =======================================================
add_newline() {
  if [[ -z $PS1_NEWLINE_LOGIN ]]; then
    PS1_NEWLINE_LOGIN=true
  else
    printf '\n'
  fi
}
precmd() { add_newline }

# =======================================================
# Aliases
# =======================================================
alias h="history | grep --color=auto"
alias wk="cd works && ls -FG" # | を && に修正（移動成功時のみls）

# ls 系の設定 (eza があれば使用)
if command -v eza &>/dev/null; then
  alias ls="eza"
  alias ll="eza --icons -al --group-directories-first"
  alias tree="eza --icons -al -T -L 2"
else
  # eza がない環境のフォールバック
  if [ "$OS" = "Mac" ]; then
    alias ls="ls -FG"
  else
    alias ls="ls --color=auto"
  fi
  alias ll="ls -al"
fi

alias dc="docker compose"
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

# global alias
alias -g A="| awk"
alias -g G="| grep --color=auto"
alias -g H="| head"
alias -g T="| tail"

# =======================================================
# fzf (fuzzy finder)
# =======================================================
_fzf_key_bindings_locations=(
  '/usr/share/doc/fzf/examples/key-bindings.zsh'
  '/usr/share/fzf/key-bindings.zsh'
  "$HOME/.fzf/shell/key-bindings.zsh"
)

if command -v brew &>/dev/null; then
  _fzf_key_bindings_locations=($(brew --prefix)/opt/fzf/shell/key-bindings.zsh "${_fzf_key_bindings_locations[@]}")
fi

for _fzf_file in "${_fzf_key_bindings_locations[@]}"; do
  if [[ -f "$_fzf_file" ]]; then
    source "$_fzf_file"
    break
  fi
done
unset _fzf_key_bindings_locations _fzf_file

# =======================================================
# nvm (Node Version Manager)
# =======================================================
export NVM_DIR="$HOME/.nvm"

if command -v brew &>/dev/null; then
  nvm_prefix="$(brew --prefix)/opt/nvm"
  [ -s "$nvm_prefix/nvm.sh" ] && . "$nvm_prefix/nvm.sh"
  [ -s "$nvm_prefix/etc/bash_completion.d/nvm" ] && . "$nvm_prefix/etc/bash_completion.d/nvm"
elif [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
fi
