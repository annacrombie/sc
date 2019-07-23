jq_() {
  typeset -a args=(--monochrome-output)
  typeset nofile
  typeset debug;

  while [[ -n "$@" ]]; do
    case "$1" in
      c) args=(--monochrome-output --compact-output);;
      r) args=(--monochrome-output --raw-output);;
      slurp) args+="--slurp";;
      debug) debug=true;;
      s) nofile=true;;
      *) break;;
    esac; shift
  done

  args=($args -L"${mu_dirs[jq]}")

  #typeset lim=${mu_limit}
  if [[ $nofile ]]; then
    typeset jq="import \"mu_common\" as mu; $1"
  else
    typeset jq="${mu_dirs[jq]}/$1"
    [[ ! -f "$jq" ]] && die_ "no such jq file '$jq'"
  fi

  typeset data="$2"
  shift 2

  typeset k v

  typeset -A param=($@)

  [[ -z $param[dkind] ]] && if [[ $mu_tty ]]; then
    param[dkind]="nice"
  else
    param[dkind]="raw"
  fi

  for k v in ${(kv)param}; do
    args=($args --arg "$k" "$v")
  done

  if [[ ($param[dkind] = "nice" || ! $mu_tty) ]]; then
    args+="--raw-output"
  fi

  if [[ $nofile ]]; then
    args=($args "$jq")
  else
    args=($args --from-file "$jq")
  fi

  args+="$data"

  [[ $debug ]] && echo jq $args >&2
  jq $args || \
    die_ "jq error in $jq\nwhile parsing $data" &&
    log_debug_ "$(cat $data)"
}
