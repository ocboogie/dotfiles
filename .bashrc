#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '


#if [ $(tty) = "/dev/tty1" ]; then
#  export WLC_REPEAT_DELAY=300
#  export WLC_REPEAT_RATE=45
#  export GTK_CSD=0
#  export XKB_DEFAULT_LAYOUT=us
#  export XKB_DEFAULT_VARIANT=colemak
#  sway
#fi
