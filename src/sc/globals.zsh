typeset -g sc_api_proto="https"
typeset -g sc_api_base="api.soundcloud.com"
typeset -g sc_api="$sc_api_proto://$sc_api_base"
typeset -g sc_keys=()
typeset -g sc_keyfile="keys"
typeset -g sc_keyid=1
typeset -gA sc_dirs=(
  base   "$sc_path/sc_data"
  cache  "$sc_path/sc_data/cache"
  api    "$sc_path/sc_data/cache/$sc_api_base"
  tracks "$sc_path/sc_data/tracks"
  jq     "$sc_path/src/jq"
)

[[ -t 1 ]] && typeset -g sc_tty=true
[[ -t 0 ]] || typeset -g sc_pipe=true
