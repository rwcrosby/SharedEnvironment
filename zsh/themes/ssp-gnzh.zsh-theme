# Based on bira theme

setopt prompt_subst

() {

local PR_USER PR_USER_OP PR_PROMPT PR_HOST

# Check the UID
if [[ $UID -ne 0 ]]; then # normal user
  PR_USER='%F{green}%n%f'
  PR_USER_OP='%F{green}%#%f'
  PR_PROMPT='%K{yellow}%F{black} %f%k'
else # root
  PR_USER='%F{red}%n%f'
  PR_USER_OP='%F{red}%#%f'
  PR_PROMPT='%F{red}➤%f'
fi

# Format the time
PR_TIME='%K{yellow}%F{black}%*%f%k'

# In a devcontainer?
if [ -f /.dockerenv ]; then
  PR_HOST="%K{white}%F{blue}%M|%f%k"
else
  PR_HOST="%K{blue}%F{white}%M|%f%k"
fi

# Display an emoji...because why not

PR_EMOJI=$' \U1f43f'
# PR_EMOJI=$'?'

local return_code="%(?..%F{red}%? ↵%f)"

# local user_host="${PR_USER}%F{cyan}@${PR_HOST}"
# local user_host="${PR_HOST}"
local current_dir="%K{cyan}%F{white}$(prompt_dir)%F{black}%f%k"
# local git_branch='$(git_prompt_info)'
local git_branch=''
local venv_prompt='$(virtualenv_prompt_info)' 

PROMPT="╭─${venv_prompt}${user_host}${current_dir}${git_branch}$PR_EMOJI
╰─$PR_TIME$PR_PROMPT "
RPROMPT="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%K{magenta}%F{white}|"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f%k"
ZSH_THEME_RUBY_PROMPT_PREFIX="%F{red}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%f"
ZSH_THEME_VIRTUALENV_PREFIX="%K{green}%F{white}"
ZSH_THEME_VIRTUALENV_SUFFIX="|%f%k"

}
