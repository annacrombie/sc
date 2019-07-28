typeset -g prog_name="mu"
typeset -g mu_version="0.1.0"
typeset -g mu_api_proto="https"
typeset -g mu_verbosity=0
typeset -gA mu_expiration=(
  cache   3600
  resolve 86400
  tracks  inf
)
typeset -gA mu_dirs=(
  base   "$mu_path/data"
  cache  "$mu_path/data/cache"
  tracks "$mu_path/data/tracks"
  jq     "$mu_path/src/jq"
  config "$HOME/.config/mu"
)
typeset -g mu_cmd_dirs=("$mu_path/src/cmds")
typeset -g mu_cfg_file="$mu_dirs[config]/config.zsh"
typeset -ga mu_tmpfiles=()
typeset -gA mu_cmd_alias=(
  f fetch
  F filter
  s sort
  d describe
  u users
  # followings
  # followers
  t tracks
  r resolve
  l library
  p play
  c count
  # prune
)

[[ -t 1 ]] && typeset -g mu_tty=true
[[ -t 0 ]] || typeset -g mu_pipe=true
