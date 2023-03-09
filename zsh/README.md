---
title: ZSH Shell Notes
---

# Installation

Does not require dotbot, no symlinks

- Install oh-my-zsh
- Update `.zshrc` in the appropriate places
```zsh
    ZSH_THEME="bowser"
    ZSH_CUSTOM=~/SharedEnvironment/zsh
    plugins=(virtualenv)
    source $ZSH_CUSTOM/zshrc
```