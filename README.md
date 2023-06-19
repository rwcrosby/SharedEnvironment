# Shared Environment

This is a simple project holding the various files that are shared amongst the Mac and Linux systems. See the individual directories for details.

- Containers
- Fish Shell
- LaTeX
- Microsoft templates
- Python
- TMUX
- Z Shell

- Obsolete Sections
  - Bash Shell (Obsolete)
  - EMACS (Obsolete)
  - Terminator (Obsolete)

## `dot` file Handling

- Configuration in `dotbot.conf.yaml`
- Installation
  - MacOS
```shell
brew install dotbot
rm -rf ~/.config/fish
dotbot -c ~/Projects/SharedEnvironment/dotbot.conf.yaml`
```
  - Linux
```shell
cd ~/Projects
git clone vhttps://github.com/anishathalye/dotbot.git
rm -rf ~/.config/fish
~/Projects/dotbot/dotbot -c ~/Projects/SharedEnvironment/dotbot.conf.yaml`
```

  - `brew install dotbot`
  - `rm -rf ~/.config/fish`
  - `dotbot -c ~/SharedEnvironment/dotbot/dotbot.conf.yaml`

## Useful commands:
 
- Update all git projects in a directory:

  `find . -type d -name .git -exec /bin/bash -c "cd {}/..; pwd; git pull" \;`

## MacOS Hints

- Renaming multiple files

  https://tidbits.com/2018/06/28/macos-hidden-treasures-batch-rename-items-in-the-finder/