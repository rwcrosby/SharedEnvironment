# -*- coding: utf-8 -*-

set sdir (dirname (status --current-filename))

# Platform dependent settings

switch (uname)
    case Linux
        set  LDLIB LD_LIBRARY_PATH
        set -x TIME /usr/bin/time --verbose
    case Darwin
        set LDLIB DYLD_LIBRARY_PATH
        set -x TIME /usr/bin/time -l
end

# My Directories

set PATH ~/.local/bin $PATH

set MANPATH ~/.local/share/man $MANPATH

set -x $LDLIB ~/.local/lib64:$$LDLIB
set -x $LDLIB ~/.local/lib:$$LDLIB

if test (uname) = "Linux"
    set -x $LDLIB ~/.local/lib64:"$$LDLIB"
    set -x $LDLIB ~/.local/lib:"$$LDLIB"
end

# Add CUDA if available

if test -d /usr/local/cuda
    set -x $LDLIB /usr/local/cuda/lib64:"$$LDLIB"
end

# Find my functions

set -g fish_function_path $sdir/functions $fish_function_path

# Prompt handling

set -g prompt_background white

set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_showuntrackedfiles 1

set -g  __fish_git_prompt_color cyan -b $prompt_background

set -g fish_prompt_pwd_dir_length 0

set -g VIRTUAL_ENV_DISABLE_PROMPT 1

# Change a couple of colors to make it all a little cleaner

set -U fish_color_escape brmagenta
set -U fish_color_operator magenta

# Hook direnv

eval (direnv hook $SHELL)

# Directory formatting

eval (dircolors -c $sdir/dircolors)
set -g LS_OPTIONS --color=auto
set -x LC_COLLATE C

# Less syntax highlighting

if test -e /usr/share/source-highlight/src-hilite-lesspipe.sh
   set SH /usr/share/source-highlight/src-hilite-lesspipe.sh
else
   set SH src-hilite-lesspipe.sh
end

set -x LESSOPEN "| $SH %s"
set -x LESS '-SR '

# Greeting
set fish_greeting "🐿  "(date)

# Default pager and editor

set -x PAGER less
set -x EDITOR nano