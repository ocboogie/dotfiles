abbr -a ls exa
abbr -a l 'exa -albF --git'

function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr --add dotdot --regex '^\.\.+$' --function multicd

bind --mode insert \cp up-or-search
bind --mode insert \cn down-or-search
bind --mode insert \cr history-pager
bind --mode insert -k nul accept-autosuggestion

starship init fish | source
zoxide init fish | source
