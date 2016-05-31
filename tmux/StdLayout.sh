#!/bin/bash

tmux rename-window mc
tmux splitw -h -p 50
tmux splitw -v -p 50

tmux new-window
tmux splitw -h -p 50

tmux select-window -t 0
tmux select-pane -t 0
mc
