function fish_prompt


    set_color green -b $prompt_background
    echo -n $PROMPT_LEAD_CHAR
    # echo -n '🐿  '
    # echo -n '🐠  '
    # echo -n '🐟  '

	set_color red -b $prompt_background
	echo -n (~/SharedEnvironment/python/ShellPrompt.py)
	set_color green -b $prompt_background
	echo -n $PROMPT_TRAIL_CHAR

	set_color normal

end
