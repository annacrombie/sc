search_() {
  typeset ep="$1"; shift
  typeset query="$@"
  [[ -z $query ]] && die_ "no query given"
  query="${query// /+}"

  get_ -k "?$query" "$ep" 'q' "$query"

  output_ $returned $ep
}

resolve_() {
  typeset pl="$1"; shift
  typeset d="$sc_dirs[api]"
  typeset f="$d/resolve/${pl}@"
  typeset rsv

  if [[ -L "$f" ]]; then
    if is_fresh_ "$f" "$sc_expiration[resolve]"; then
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
    if [[ $sc_expiration[resolve] != inf ]]; then
      sc_expiration[resolve]=inf
      resolve_ "$pl"
      return
    else
      die_ "failed to resolve $pl :("
    fi
  fi

  mkdir -p "${f:h}"

  ln -sr "$d/$rsv$" "$f"
  get_ "$rsv"
  typeset -a rsv=(${(s:/:)rsv})
  return_ "$rsv$"
}

output_() {
  typeset data=$1
  typeset args=("$data" limit $sc_opt[take])

  if [[ $sc_tty ]]; then
    typeset f="disp/$2.jq"
    typeset jq="${sc_dirs[jq]}"
    typeset cols="$(head -n 1 "$jq/$f")"
    cols="${cols##\#}"

    jq_ r "$f" $args |
      if [[ -n $cols ]]; then
        column -s '|' -t -N "$cols"
      else
        cat -
      fi
  else
    typeset f="raw/desc/$2.jq"
    jq_ c "$f" $args
  fi
}

eval_loop_() {
  typeset -A callbacks=($@)

  jq_ r s '. | sc::zstream' - | while read -r line; do
    eval "typeset -A data=(${line})"
    typeset cb=$callbacks[$data[type]]
    [[ -z $cb ]] && die_ "invalid datatype $data[type]"

    $cb ${(kv)data}
  done
}
