# My aliases

if [ !$(command -v bat) ]; then
    if [ $(command -v batcat) ]; then
        alias bat=batcat
    fi
fi

alias b="$mybat -Ppn"

alias mc="mc -X --nosubshell"

alias kc=kubectl

alias l=less 

alias la='ls -lAh --color=auto'
alias ll='ls -lh --color=auto'
alias ls='ls --color=auto'