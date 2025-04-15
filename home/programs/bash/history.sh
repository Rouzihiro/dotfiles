HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=erasedups:ignoredups:ignorespace
HISTTIMEFORMAT="%F %T"
PROMPT_COMMAND='history -a'
shopt -s histappend
shopt -s cmdhist
shopt -s checkwinsize
[[ $- == *i* ]] && stty -ixon

