function fish_right_prompt

	set -g __fish_git_show_informative_status 0

	echo -n (fish_git_prompt)
	set_color magenta -b $prompt_background

    if test -n "$VIRTUAL_ENV"
       set_color blue -b $prompt_background
       echo -n ' '(basename $VIRTUAL_ENV)
    end

	set_color magenta -b $prompt_background

	echo -n ' '(date "+%H:%M:%S")' '

	set_color normal

end