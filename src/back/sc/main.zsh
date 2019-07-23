typeset -g sc_api_base="api.soundcloud.com"
typeset -g sc_api="$mu_api_proto://$sc_api_base"
typeset -g sc_key=""
mu_dirs[api]="$mu_path/data/cache/$sc_api_base"

load_config_() {
  log_debug_ "loading config file $mu_cfg_file"
  if [[ ! -f "$mu_cfg_file" ]]; then
    echo "export SOUNDCLOUD_CLIENT_ID=\"\"" > "$mu_cfg_file"
  fi

  source "$mu_cfg_file"
  typeset -g sc_key="$SOUNDCLOUD_CLIENT_ID"
}

search_() {
  typeset ep="$1"; shift
  typeset query="$@"
  [[ -z $query ]] && die_ "no query given"
  query="${query// /+}"

  get_ -k "?$query" "$ep" 'q' "$query"

  output_ $returned $ep
}

resolve_() {
  typeset pl="$1"

  if [[ -z "$pl" ]]; then
    die_ "no arguments to resolve_"
  else
    shift
  fi

  typeset d="$mu_dirs[api]"
  typeset f="$d/resolve/${pl}@"
  typeset rsv

  if [[ -L "$f" ]]; then
    if is_fresh_ "$f" "$mu_expiration[resolve]"; then
      returned="${${(s:/:)f:A}[-2,-1]}"
      return
    fi
  fi

  get_api_url_ 'resolve' 'url' "$sc_api_proto://soundcloud.com/$pl"
  typeset url="$returned"

  rsv="$(wget -qSO- --spider --max-redirect=0 "$url" 2>&1 | \
    grep Location | \
    sed "s/.*Location: $sc_api_proto:\/\/$sc_api_base\/\(.*\)?.*/\1/g")"

  if [[ -z "$rsv" ]]; then
    if [[ $mu_expiration[resolve] != inf ]]; then
      mu_expiration[resolve]=inf
      resolve_ "$pl"
      return
    else
      die_ "failed to resolve $pl :("
    fi
  fi

  mkdir -p "${f:h}"

  ln -fsr "$d/$rsv$" "$f"
  get_ "$rsv"
  typeset -a rsv=(${(s:/:)rsv})
  return_ "$rsv$"
}

get_api_url_() {
  typeset endpoint="$1"; shift
  typeset -A params=($@)

  [[ -z "$sc_key" ]] && die_ "please set \$SOUNDCLOUD_CLIENT_ID"
  params[client_id]="$sc_key"
  build_paramstr_ ${(kv)params}

  return_ "${sc_api}/${endpoint}?${returned}"
}
