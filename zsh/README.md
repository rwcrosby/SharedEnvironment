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
source $ZSH_CUSTOM/.zshrc
```
# Notes

- <2023-10-10 Tue 10:12> Fixing aliases

    - Moved my aliases to alias.zsh
    - Moved my functions to functions.zsh

- <2023-10-10 Tue 13:08> Found some new utilities

