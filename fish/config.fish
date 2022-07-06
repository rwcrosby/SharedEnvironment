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

        set fish_user_paths /usr/local/opt/coreutils/libexec/gnubin $fish_user_paths
        set MANPATH /usr/local/opt/coreutils/libexec/gnuman $MANPATH

        # Homebrew github access token
        set -x HOMEBREW_GITHUB_API_TOKEN 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

end

# My Directories

set fish_user_paths ~/.local/bin $fish_user_paths

set MANPATH ~/.local/share/man $MANPATH

set -x $LDLIB ~/.local/lib64:$$LDLIB
set -x $LDLIB ~/.local/lib:$$LDLIB

if test (uname) = "Linux"
    set -x $LDLIB ~/.local/lib64:"$$LDLIB"
    set -x $LDLIB ~/.local/lib:"$$LDLIB"
end

# Add CUDA if available

test -d /usr/local/cuda; and set -x $LDLIB /usr/local/cuda/lib64:"$$LDLIB"

# Add texlive if it exists

set texyear 2020

if test -d /usr/local/texlive/$texyear

   set fish_user_paths /usr/local/texlive/$texyear/bin/x86_64-linux $fish_user_paths
   set MANPATH /usr/local/texlive/$texyear/texmf-dist/doc/man $MANPATH
   set INFOPATH /usr/local/texlive/$texyear/texmf-dist/doc/info $INFOPATH

end

# Add SNAP package manager if installed

test -d /var/lib/snapd/snap/bin; and set fish_user_paths /var/lib/snapd/snap/bin $fish_user_paths

# Find my functions

set -g fish_function_path $sdir/functions $fish_function_path

# Prompt handling

set -g prompt_background white

set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_showuntrackedfiles 1

set -g  __fish_git_prompt_color cyan -b $prompt_background

set -g fish_prompt_pwd_dir_length 1

set -g VIRTUAL_ENV_DISABLE_PROMPT 1

set -gx PROMPT_MAX_LEN 40

# Change a couple of colors to make it all a little cleaner

set -U fish_color_escape brmagenta
set -U fish_color_operator magenta

# Hook direnv

direnv hook fish | source

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

if test -d $PVE

  pushd $PVE > /dev/null

  for d in */
      set VE (string trim -c '/' $d)
      alias $VE="source $PVE/$VE/bin/activate.fish"
  end

  popd > /dev/null

end

# pyenv support

# Since all we're using pyenv for is getting python distributions we don't actually
# install the hooks

test -d ~/.pyenv; and set -xg PYENV_ROOT ~/.pyenv
test -d ~/.pyenv/pyenv/bin; and set fish_user_paths ~/.pyenv/pyenv/bin $fish_user_paths

# Rust support

test -d ~/.cargo/bin; and set fish_user_paths ~/.cargo/bin $fish_user_paths

# Iterm2 Shell Integration

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish