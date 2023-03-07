function fish_prompt


    set_color green -b $prompt_background
    echo -n 'α '
    # echo -n '🐿  '
    # echo -n '🐠  '
    # echo -n '🐟  '

	set_color red -b $prompt_background
	echo -n (~/SharedEnvironment/python/ShellPrompt.py)
	set_color green -b $prompt_background
	echo -n ' Ω⇒ '

	set_color normal

end
