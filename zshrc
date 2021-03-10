# zinit
source ~/.zinit/bin/zinit.zsh # zinit bootstrap

zinit wait lucid light-mode for \
      zdharma/history-search-multi-word \
  depth"1" \
      jeffreytse/zsh-vi-mode \
  atinit"zicompinit; zicdreplay" \
      zdharma/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions \

# History
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt INC_APPEND_HISTORY_TIME # "Writes to history from all terminals but that 

# Keybinds
bindkey -v # set vi mode

bindkey ^P up-line-or-history   # Bind C-P to history up
bindkey ^N down-line-or-history # Bind C-N to history down

# Aliases
alias ls='exa'            # ls
alias l='exa -albF --git' # list, size, type, git
alias ..="cd .."
alias ...="cd ../.."

# Start starship
eval "$(starship init zsh)"
