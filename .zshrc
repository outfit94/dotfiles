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