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
# Disable git status display

See: https://stackoverflow.com/questions/12765344/oh-my-zsh-slow-but-only-for-certain-git-repo#25864063

```shell
git config --global --add oh-my-zsh.hide-info 1
git config --global --add oh-my-zsh.hide-status 1
git config --global --add oh-my-zsh.hide-dirty 1
```

# Updated utilities

- `duf` replacing `df` (best)
- `dfc` replacing `df` (better)
- `tldr` simplified `man`
- `ncdu` simplified `du`
- `bat` replacing `cat` (pager, syntax highlighting)

# Notes

- <2023-10-10 Tue 10:12> Fixing aliases

    - Moved my aliases to alias.zsh
    - Moved my functions to functions.zsh

- <2023-10-10 Tue 13:08> Found some new utilities

