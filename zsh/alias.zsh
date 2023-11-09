# My aliases

if [ $(command -v batcat) ]; then
    mybat=batcat
else
    mybat=bat
fi
alias b="$mybat -Ppn"

[ $(command -v lesspipe.sh) ] && export LESSOPEN="|$(which lesspipe.sh) %s"
[ $(command -v lesspipe) ] && export LESSOPEN="|$(which lesspipe) %s"
[ $(command -v highlight) ] && 	export LESSOPEN="| $(which highlight) %s --out-format xterm256 -l --force -s solarized-light --no-trailing-nl"

alias l=less 

alias mc="mc -X --nosubshell"

alias kc=kubectl