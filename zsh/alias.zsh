# My aliases

alias b="bat -Ppn"

[ $(command -v lesspipe.sh) ] && export LESSOPEN="|$(which lesspipe.sh) %s"
alias l=less 

alias mc="mc -X --nosubshell"

alias kc=kubectl