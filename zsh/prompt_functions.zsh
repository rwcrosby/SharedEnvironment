GLYPH_PROMPT_TRUNCATION_SYMBOL='⋯'   # DejaVu Sans Mono glyph for prompt truncation

prompt_dir() {
  # Validate truncation thresholds and set defaults if required
  [[ $NUM_DIRS_LEFT_OF_TRUNCATION -le 0 ]] && NUM_DIRS_LEFT_OF_TRUNCATION=1
  [[ $NUM_DIRS_RIGHT_OF_TRUNCATION -le 0 ]] && NUM_DIRS_RIGHT_OF_TRUNCATION=2

  # Refer https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
  local prompt_truncation_symbol="${GLYPH_PROMPT_TRUNCATION_SYMBOL}"
  local prompt_end_symbol="${GLYPH_PROMPT_END_SYMBOL}"
  local total_dirs=$(($NUM_DIRS_LEFT_OF_TRUNCATION+$NUM_DIRS_RIGHT_OF_TRUNCATION+1))
  local dir_path_full="%F{${COLOR_PROMPT_TEXT}}%d%f"
  local dir_path_full="%d"
  local dir_path_truncated="%-${NUM_DIRS_LEFT_OF_TRUNCATION}d/${prompt_truncation_symbol}/%${NUM_DIRS_RIGHT_OF_TRUNCATION}d"

  echo "%(${total_dirs}C.${dir_path_truncated}.${dir_path_full})"
}  