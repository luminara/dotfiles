#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

fastfetch -c ~/.config/fastfetch/small.jsonc

PS1='\[\033[01;32m\]\u@\h\[\033[00m\]: \[\033[01;34m\]\W\[\033[00m\]\\$ '


#_______________________Shell Integrations____________________________

eval "$(zoxide init bash)"

#______________________Environment Varibles___________________________

export EDITOR=/usr/bin/nvim
export MANPAGER='nvim +Man!'
export MANPATH='/usr/local/man:/usr/local/share/man:/usr/share/man'
export PATH=$PATH:/home/squares/.local/bin

#____________________________Aliases__________________________________

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias vim="nvim"
alias todo="nvim ~/todo/todo.md"
