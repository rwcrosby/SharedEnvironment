function fish_prompt

    set_color -b $prompt_background

    echo -n '🐿  '
    # echo -n '🐠  '
    # echo -n '🐟  '

	set_color red -b $prompt_background
	echo -n (~/SharedEnvironment/python/ShellPrompt.py) '⤇ '

	set_color normal

end
