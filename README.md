# Shared Environment

This is a simple project holding the various files that are shared amongst the Mac and Linux systems. See the individual directories for details.

- Bash Shell
- EMACS
- Fish Shell
- LaTeX
- Python
- Terminator (Obsolete)
- TMUX


 ## Useful commands:
 
- Update all git projects in a directory:

  `find . -type d -name .git -exec /bin/bash -c "cd {}/..; pwd; git pull" \;`
