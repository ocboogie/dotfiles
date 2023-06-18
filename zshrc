# zinit
source ~/.zinit/bin/zinit.zsh # zinit bootstrap

zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start; bindkey '^ ' autosuggest-accept" \
    zsh-users/zsh-autosuggestions

# Additional completion definitions
zinit ice wait lucid blockf atpull'zinit creinstall -q .' 
zinit light zsh-users/zsh-completions

# Use system clipboard in vi mode
typeset -g ZSH_SYSTEM_CLIPBOARD_USE_WL_CLIPBOARD='true'
zinit ice wait lucid
zinit light kutsan/zsh-system-clipboard

# fast-syntax-highlighting
# zinit ice wait lucid atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" 
# zinit light zdharma-continuum/fast-syntax-highlighting

# zdharma/history-search-multi-word
zstyle ":history-search-multi-word" page-size "11"
zinit ice wait"1" lucid
zinit light zdharma-continuum/history-search-multi-word

# forgit
zinit ice wait lucid
zinit light 'wfxr/forgit'

# zsh-z
# zinit ice wait lucid
# zinit light 'agkozak/zsh-z'
zinit load agkozak/zsh-z

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

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/boogie/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/boogie/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/boogie/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/boogie/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

