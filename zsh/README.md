---
title: ZSH Shell Notes
---

# Installation

Does not require dotbot, no symlinks

- Install oh-my-zsh
- Update `.zshrc` adding the following just before oh-my-zsh is sourced
    
```zsh
ZSH_THEME="bowser"
ZSH_CUSTOM=~/Projects/SharedEnvironment/zsh
plugins=(virtualenv)
source $ZSH_CUSTOM/zshrc
```