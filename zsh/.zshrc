# Personal zsh customizations

# Find out where this script is located

HERE=${0:a:h:h}

# Avoid duplicates

typeset -U PATH path manpath

# Set platform dependent variables

case $OSTYPE in
    darwin*)

        LDLIB=DYLD_LIBRARY_PATH
        export TIME="/usr/bin/time -l"
        
        # Homebrew - Need to use real path since $HOMEBREW_PREFIX isn't set yet
        [[ -f /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)
        # Disable automatic cleanup
        export HOMEBREW_NO_INSTALL_CLEANUP=1

        # Use the gnu utilities

        if [ -d $HOMEBREW_PREFIX/opt/coreutils/libexec ]; then
            path=($HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin $path)
            manpath=($HOMEBREW_PREFIX/opt/coreutils/libexec/gnuman $manpath)
        fi 

        # MacTeX
        [ -d /Library/TeX/texbin ] && path=(/Library/TeX/texbin $path)

        ;;

    linux*)
        
        LDLIB=LD_LIBRARY_PATH
        export TIME="/usr/bin/time --verbose"

        # Set the display for wsl
        [[ $(uname -a) == *WSL* ]] && export DISPLAY=$(route -n | grep UG | head -n1 | awk '{print $2}'):0
        
        ;;

esac

# My directories

[[ -d ~/.local/bin ]] && path=(~/.local/bin $path)
[[ -d ~/.local/share/man ]] && manpath=(~/.local/share/man $manpath)

# Colors

if [[ "$TERM" != "dumb" ]]; then

    eval $(dircolors -b ${HERE}/zsh/dircolors)

    [[ $(command -v lesspipe.sh) ]] && export LESSOPEN="|$(which lesspipe.sh) %s"
    [[ $(command -v lesspipe) ]] && export LESSOPEN="|$(which lesspipe) %s"
    [[ $(command -v highlight) ]] && 	export LESSOPEN="| $(which highlight) %s --out-format xterm256 -l --force -s solarized-light --no-trailing-nl"

    export LESS=' -R '

fi

# Rust
[ -d ~/.cargo/bin ] && path=(~/.cargo/bin $path)

# Direnv
[ $(command -v direnv) ] && eval "$(direnv hook zsh)"

# Python
PVE=~/.local/PVE
[[ -d $PVE ]] && {

    pushd $PVE &> /dev/null

    for d in *(N) 
        alias ${d%/}="source $PVE/${d%/}/bin/activate"

    popd &> /dev/null

    [ -d $HERE/python ] && export PYTHONPATH=$HERE/python

    # Since all we're using pyenv for is getting python distributions 
    # we don't actually install the hooks

    [ -d ~/.pyenv ] && export PYENV_ROOT=~/.pyenv
    [ -d ~/.pyenv/bin ] && export path=(~/.pyenv/bin $path)

}

# Default editor
[[ $(command -v nano) ]] && {
    export EDITOR=$(which nano)
    export VISUAL=$(which nano)
}

# Light or dark window settings

if [[ -n $DARK_TERMINAL ]]; then

    # DRACULA COLOR SCHEME # Background 3B # Current Line 3C # Foreground E7 # Comment 67 # Cyan 9F # Green 78 # Orange DE # Pink D4 # Purple B7 # Red D2 # Yellow E5 BLK="D4" CHR="DE" DIR="B7" EXE="78" REG="E7" HARDLINK="9F" SYMLINK="9F" MISSING="67" ORPHAN="D2" FIFO="E5" SOCK="E5" OTHER="D2" 
    export NNN_FCOLORS="D4DEB778E79F9F67D2E5E5D2"
    export BAT_THEME="Visual Studio Dark+"

else

    export NNN_FCOLORS='c1e21b58006033f7c6d6abc4'
    export BAT_THEME="GitHub"

fi

# nnn file manager configuration

export NNN_OPENER="batcat --paging always"
export NNN_OPTS="dc"

# Set emacs editing mode
bindkey -e

# Container locations

export PORTAINER_REGISTRY=${PORTAINER_REGISTRY:-"docker.io"}