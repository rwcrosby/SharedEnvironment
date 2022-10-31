# Shared Environment

This is a simple project holding the various files that are shared amongst the Mac and Linux systems. See the individual directories for details.

- Bash Shell
- EMACS
- Fish Shell
- LaTeX
- Microsoft templates
- Python
- Terminator (Obsolete)
- TMUX
- Z Shell

## `dot` file Handling

- Configuration in `dotbot.conf.yaml`
- Installation
  - `brew install dotbot`
  - `rm -rf ~/.config/fish`
  - `dotbot -c ~/SharedEnvironment/dotbot/dotbot.conf.yaml`

## Useful commands:
 
- Update all git projects in a directory:

  `find . -type d -name .git -exec /bin/bash -c "cd {}/..; pwd; git pull" \;`

## MacOS Hints

- Renaming multiple files

  https://tidbits.com/2018/06/28/macos-hidden-treasures-batch-rename-items-in-the-finder/