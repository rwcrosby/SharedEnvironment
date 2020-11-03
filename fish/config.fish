# -*- coding: utf-8 -*-

set sdir (dirname (status --current-filename))

# Platform dependent settings

switch (uname)
    
    case Linux

        set  LDLIB LD_LIBRARY_PATH
        set -x TIME /usr/bin/time --verbose
        set PATH /sbin $PATH

    case Darwin
        
        set LDLIB DYLD_LIBRARY_PATH
        set -x TIME /usr/bin/time -l
        
        # Homebrew - Disable automatic cleanup
        set -x HOMEBREW_NO_INSTALL_CLEANUP 1

        # Homebrew paths

        set PATH /usr/local/opt/coreutils/libexec/gnubin $PATH
        set MANPATH /usr/local/opt/coreutils/libexec/gnuman $MANPATH

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

# Add texlive if it exists

if test -d /usr/local/texlive/2019

   set PATH /usr/local/texlive/2019/bin/x86_64-linux $PATH
   set MANPATH /usr/local/texlive/2019/texmf-dist/doc/man $MANPATH
   set INFOPATH /usr/local/texlive/2019/texmf-dist/doc/info $INFOPATH

end

# Add SNAP package manager if installed

if test -d /var/lib/snapd/snap/bin 
    set PATH /var/lib/snapd/snap/bin $PATH
end

# Find my functions

set -g fish_function_path $sdir/functions $fish_function_path

# Prompt handling

set -g prompt_background white

#set -g __fish_git_prompt_showdirtystate 1
#set -g __fish_git_prompt_showuntrackedfiles 1

set -g  __fish_git_prompt_color cyan -b $prompt_background

set -g fish_prompt_pwd_dir_length 1

set -g VIRTUAL_ENV_DISABLE_PROMPT 1

set -gx PROMPT_MAX_LEN 40

# Change a couple of colors to make it all a little cleaner

set -U fish_color_escape brmagenta
set -U fish_color_operator magenta

# Hook direnv

eval (direnv hook fish)

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

# If a dump terminal (from emacs tramp) reset the prompt

if test "$TERM" = "dumb"
  function fish_prompt
    echo "\$ "
  end

  function fish_right_prompt; end
  function fish_greeting; end
  function fish_title; end
end

# Add alias for Python virtual environments

set PVE ~/.local/PVE

pushd $PVE > /dev/null

for d in */
    set VE (string trim -c '/' $d)
    alias $VE="source $PVE/$VE/bin/activate.fish"
end

popd > /dev/null

# pyenv support

# Since all we're using pyenv for is getting python distributions we don't actually
# install the hooks

if test -d ~/.pyenv
   set -xg PYENV_ROOT ~/.pyenv

   if test -d ~/.pyenv/bin
      set PATH ~/.pyenv/bin $PATH
   end
end

# Rust support

if test -d ~/.cargo

   if test -d ~/.cargo/bin
      set PATH ~/.cargo/bin $PATH
   end
end
