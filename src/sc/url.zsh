build_paramstr_() {
  typeset -A params=($@)
  typeset key val

  typeset paramlen=${#params}
  typeset i=0

  typeset ret=""

  for key val in ${(kv)params}; do
    ret+="${key}=${val}"
    i=$((i+1))
    [[ $i -lt $paramlen ]] && ret+="&"
  done

  return_ "$ret"
}

build_url_() {
  typeset base="$1"; shift
  typeset -A params=($@)

  [[ -z "$sc_key" ]] && die_ "please set \$SOUNDCLOUD_CLIENT_ID"
  params[client_id]="$sc_key"

  build_paramstr_ ${(kv)params}

  return_ "${base}?${returned}"
}

get_api_url_() {
  typeset endpoint="$1"; shift
  typeset -A params=($@)

  build_url_ "${sc_api}/${endpoint}" ${(kv)params}

  return_ "$returned"
}

get_() {
  typeset key force

  while [[ -n "$@" ]]; do
    case "$1" in
      '-k') key=$2;shift;;
      '-f') force=true;;
      *) break;;
    esac; shift
  done

  typeset endpoint="$1"; shift
  typeset -A params=($@)
  get_api_url_ $endpoint ${(kv)params}
  typeset url="$returned"

  [[ -n "$key" ]] && key="--key=${key}"

  typeset bb="${sc_expiration[cache]}"
  [[ ($force || $sc_opt[force]) ]] && bb="0"

  log_debug_ "$url"

  ret="$(wcache_ --best-by=$bb --cache=$sc_dirs[cache] \
    $key --echo-output "${url}")"

  [[ -z "$ret" ]] && die_ "failed to get anything"

  return_ "$ret"
}

