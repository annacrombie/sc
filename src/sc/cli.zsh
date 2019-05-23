sc_cli_main_() {
  typeset cmd_dir="$sc_path/src/sc/cmds"

  sc_parse_opts_ $@

  [[ "$sc_cmd_alias[${sc_opt[cmd]}]" ]] && \
    sc_opt[cmd]="$sc_cmd_alias[${sc_opt[cmd]}]"

  typeset func="cmd_${sc_opt[cmd]}_"

  if [[ ! -f "$cmd_dir/${sc_opt[cmd]}.zsh" ]]; then
    die_ "invalid command \"$sc_opt[cmd]\""
  fi

  . "$cmd_dir/${sc_opt[cmd]}.zsh"

  load_config_
  initialize_dirs_ ${sc_dirs}
  $func

  cleanup_
}
