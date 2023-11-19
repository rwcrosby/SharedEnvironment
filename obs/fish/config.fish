# -*- coding: utf-8 -*-

set sdir (dirname (status --current-filename))
set -g fish_function_path $sdir/functions $fish_function_path

# Platform dependent settings

switch (uname -a)
    
    case "*Linux*"

        set  LDLIB LD_LIBRARY_PATH
        set -x TIME /usr/bin/time --verbose

        set PATH /sbin $PATH

        string match -q "*WSL2*" (uname -a); \
            and set -x DISPLAY (route -n | grep UG | head -n1 | awk '{print $2}'):0

        set -x PROMPT_LEAD_CHAR 'α '
        set -x PROMPT_TRAIL_CHAR ' Ω⇒ '
        set GREETING_LEAD ""

    case "*Darwin*"
        
        set LDLIB DYLD_LIBRARY_PATH
        set -x TIME /usr/bin/time -l
        
        # Homebrew paths

        eval (/opt/homebrew/bin/brew   shellenv)
        set fish_user_paths $HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin $fish_user_paths
        set MANPATH $HOMEBREW_PREFIX/opt/coreutils/libexec/gnuman $MANPATH

        # Homebrew - Disable automatic cleanup
        set -x HOMEBREW_NO_INSTALL_CLEANUP 1

        set -x PROMPT_LEAD_CHAR '🐿  '
        set -x PROMPT_TRAIL_CHAR ' ⇒ '
        set GREETING_LEAD "🐿  "

        # MacTEX
        test -d /Library/TeX/texbin; and set fish_user_paths /Library/TeX/texbin $fish_user_paths

    case "*"
        echo "Unable to determine system type"
        exit -1

end

 
# My Directories

Add2Var fish_user_paths ~/.local/bin
Add2Var MANPATH ~/.local/share/man

test -d ~/.local/lib64; and set -x $LDLIB ~/.local/lib64:"$$LDLIB"
test -d ~/.local/lib; and set -x $LDLIB ~/.local/lib:"$$LDLIB"

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

type -q direnv; and direnv hook fish | source

# Directory formatting

type -q dircolors; and eval (dircolors -c $sdir/dircolors)
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
set fish_greeting $GREETING_LEAD(date)

# Default pager and editor

set -x PAGER less
set -x EDITOR nano

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
