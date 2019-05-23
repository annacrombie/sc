load_config_() {
  log_debug_ "loading config file $sc_cfg_file"
  if [[ ! -f "$sc_cfg_file" ]]; then
    echo "export SOUNDCLOUD_CLIENT_ID=\"\"" > "$sc_cfg_file"
  fi

  source "$sc_cfg_file"
  typeset -g sc_key="$SOUNDCLOUD_CLIENT_ID"
}
