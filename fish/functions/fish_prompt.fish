function fish_prompt

	set_color magenta -b $prompt_background
#    echo -n '🐟 '
#    echo -n '⚓ '

	echo -n (date "+%H:%M:%S")' '

    if test -n "$VIRTUAL_ENV"
       set_color blue -b $prompt_background
       echo -n (basename $VIRTUAL_ENV)' '
    end

	set_color normal
    set_color -b $prompt_background

	echo -n (__fish_git_prompt)' '

	set_color red -b $prompt_background
#	echo -n (prompt_pwd) '⤇  '
	echo -n (prompt_pwd) '> '

	set_color normal
    
end