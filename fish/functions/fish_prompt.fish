function fish_prompt

    set_color -b $prompt_background

    echo -n '🐟 '

	set_color red -b $prompt_background
	echo -n (~/SharedEnvironment/python/ShellPrompt.py) '⤇ '

	set_color normal
	
end
