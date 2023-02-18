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
alias ls="ls -FG"
alias dc="docker compose"
alias vi="nvim"

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

# global コマンドの途中でも展開される
alias -g A="| awk"
alias -g G="| grep --color=auto"
alias -g H="| head"
alias -g T="| tail"

# 初回シェル時のみ tmux実行
if [ $SHLVL = 1 ]; then
  tmux
fi

# nvm
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

