load_config_() {
  typeset cfg_file="$sc_dirs[config]/config.zsh"
  if [[ ! -f "$cfg_file" ]]; then
    echo "export SOUNDCLOUD_CLIENT_ID=\"\"" > "$cfg_file"
  fi

  source "$cfg_file"
  typeset -g sc_key="$SOUNDCLOUD_CLIENT_ID"
}
