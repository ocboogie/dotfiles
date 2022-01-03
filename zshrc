# zinit
source ~/.zinit/bin/zinit.zsh # zinit bootstrap

# zsh-autosuggestions
zinit ice wait lucid atload"!_zsh_autosuggest_start; bindkey '^ ' autosuggest-accept"
zinit light zsh-users/zsh-autosuggestions

# Additional completion definitions
zinit ice wait lucid blockf atpull'zinit creinstall -q .' 
zinit light zsh-users/zsh-completions

# Use system clipboard in vi mode
typeset -g ZSH_SYSTEM_CLIPBOARD_USE_WL_CLIPBOARD='true'
zinit ice wait lucid
zinit light kutsan/zsh-system-clipboard

# fast-syntax-highlighting
zinit ice wait lucid atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" 
zinit light zdharma/fast-syntax-highlighting

# zdharma/history-search-multi-word
zstyle ":history-search-multi-word" page-size "11"
zinit ice wait"1" lucid
zinit light zdharma/history-search-multi-word

# forgit
zinit ice wait lucid
zinit light 'wfxr/forgit'

# Smart tab complete
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY_TIME # "Writes to history from all terminals but that 

# Faster escaping in vi mode (see https://www.johnhawthorn.com/2012/09/vi-escape-delays/)
KEYTIMEOUT=1

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

# Alias "fuck"
if type "thefuck" > /dev/null; then
  eval $(thefuck --alias)
fi
