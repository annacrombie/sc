typeset -g sc_version="0.1.0"
typeset -g sc_api_proto="https"
typeset -g sc_api_base="api.soundcloud.com"
typeset -g sc_api="$sc_api_proto://$sc_api_base"
typeset -g sc_key=""
typeset -g sc_verbosity=0
typeset -gA sc_expiration=(
  cache   3600
  resolve 86400
  tracks  inf
)
typeset -gA sc_dirs=(
  base   "$sc_path/data"
  cache  "$sc_path/data/cache"
  api    "$sc_path/data/cache/$sc_api_base"
  tracks "$sc_path/data/tracks"
  jq     "$sc_path/src/jq"
  config "$HOME/.config/sc"
)
typeset -g sc_cfg_file="$sc_dirs[config]/config.zsh"
typeset -ga sc_tmpfiles=()

[[ -t 1 ]] && typeset -g sc_tty=true
[[ -t 0 ]] || typeset -g sc_pipe=true
