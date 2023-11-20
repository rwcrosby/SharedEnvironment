# My aliases

if [ $(command -v batcat) ]; then
    mybat=batcat
else
    mybat=bat
fi
alias b="$mybat -Ppn"

alias mc="mc -X --nosubshell"

alias kc=kubectl

alias l=less 

alias la='ls -lAh --color=auto'
alias ll='ls -lh --color=auto'
alias ls='ls --color=auto'