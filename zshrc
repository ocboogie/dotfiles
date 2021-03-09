source ~/.zinit/bin/zinit.zsh

zinit wait lucid light-mode for \
      zdharma/history-search-multi-word \
  atinit"zicompinit; zicdreplay" \
      zdharma/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions \

bindkey -v

alias ls='exa'                                      # ls
alias l='exa -albF --git'                           # list, size, type, git

eval "$(starship init zsh)"
