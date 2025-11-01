# Print the strinf 'nnn' if in the current process tree nnn

run_segment() {

    # echo "Bite me"

    [[ $(tmux run "ps -o comm= -t '#{pane_tty}'" | grep nnn) ]] && echo "NNN" 

    # [[ $(pstree $$ -s | grep nnn) ]] && echo "nnn"

	return 0
    
}
