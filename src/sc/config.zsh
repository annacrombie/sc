load_config_() {
  if [[ ! -f "$sc_cfg_file" ]]; then
    echo "export SOUNDCLOUD_CLIENT_ID=\"\"" > "$sc_cfg_file"
  fi

  source "$sc_cfg_file"
  typeset -g sc_key="$SOUNDCLOUD_CLIENT_ID"
}
