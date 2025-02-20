#!/usr/bin/env zsh

autoload colors && colors

for c in ${(o)color}
do
    print -P %F{$c}$c/%B$c%b/%K{$c}%F{black}$c/%F{white}$c%k%f
done

print -P "\u2713"