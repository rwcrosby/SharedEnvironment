#!/bin/bash

ln -s ${PWD}/tmux/tmux.conf ~/.tmux.conf 
mkdir -p ~/.config/direnv
ln -s ${PWD}/direnvrc ~/.config/direnv/direnvrc

cat << EOF > ~/.zshrc
export ZSH="$HOME/.oh-my-zsh" 
ZSH_THEME="ssp-gnzh"
ZSH_CUSTOM=~/Projects/SharedEnvironment/zsh
plugins=(virtualenv)
source \$ZSH_CUSTOM/zshrc
source \$ZSH/oh-my-zsh.sh
EOF
