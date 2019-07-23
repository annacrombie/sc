mu_cli_main_() {
  mu_parse_opts_ $@

  source "$mu_backend_path/main.zsh"

  [[ "$mu_cmd_alias[${mu_opt[cmd]}]" ]] && \
    mu_opt[cmd]="$mu_cmd_alias[${mu_opt[cmd]}]"

  typeset func="cmd_${mu_opt[cmd]}_"
  typeset file

  for dir in $mu_cmd_dirs; do
    file="$dir/${mu_opt[cmd]}.zsh"
    [[ -f "$file" ]] && break
  done

  [[ ! -f "$file" ]] && die_ "invalid command \"$mu_opt[cmd]\""

  source "$file"

  load_config_
  initialize_dirs_ ${mu_dirs}
  $func

  cleanup_
}
