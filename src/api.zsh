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
    returned="${${(s:/:)f:A}[-2,-1]}"
    return
  fi

  get_api_url_ 'resolve' 'url' "$sc_api_proto://soundcloud.com/$pl"
  typeset url="$returned"

  rsv="$(wget -qSO- --spider --max-redirect=0 "$url" 2>&1 | \
    grep Location | \
    sed "s/.*Location: $sc_api_proto:\/\/$sc_api_base\/\(.*\)?.*/\1/g")"

  [[ -z "$rsv" ]] && die_ "failed to resolve $pl :("

  mkdir -p "${f:h}"

  ln -sr "$d/$rsv$" "$f"
  get_ "$rsv"
  typeset -a rsv=(${(s:/:)rsv})
  return_ "$rsv$"
}

split_() {
  typeset ep=$1
  typeset data=$2
  typeset -a ids=($(jq -Mr '.[] | .id' $data))
  typeset i=0


  for id in $ids; do
    typeset file="${sc_dirs[api]}/$ep/$id$"
    [[ -f $file ]] && continue
    jq -Mc ".[$i]" "$data" > "$file"
    ((i+=1))
  done
}

extract_collection_() {
  typeset data="$1"

  is_coll=$(jq -Mrf "${sc_dirs[jq]}/is_collection.jq" "$data")
  [[ $is_coll = false ]] && return

  typeset f=$(mktemp)

  jq -Mc ".collection" "$data" > "$f"
  mv "$f" "$data"
}

output_() {
  typeset data=$1

  if [[ $sc_tty ]]; then
    typeset f="disp/$2.jq"
    typeset jq="${sc_dirs[jq]}"
    typeset cols="$(head -n 1 "$jq/$f")"
    cols="${cols##\#}"

    jq_ r "$f" "$data" limit $sc_opt[take] |
      if [[ -n $cols ]]; then
        column -s '|' -t -N "$cols"
      else
        cat -
      fi
  else
    typeset f="raw/desc/$2.jq"
    jq_ c "$f" "$data" limit $sc_opt[take]
  fi
}

to_json_() {
  typeset -A obj=($@)
  typeset tmp k v
  typeset -a out=()
  for k v in ${(kv)obj}; do
    if [[ $v = <-> ]]; then
      printf -v tmp '"%s":%s' $k $v
    else
      printf -v tmp '"%s":"%s"' $k $v
    fi

    out+="$tmp"
  done

  echo "{${(j:,:)out}}"
}

filter_accept_() {
  typeset -A data=($@)

  [[ -z $data[$sc_filter[1]] ]] && die_ "invalid filter"

  eval "[[ \"$data[$sc_filter[1]]\" $sc_filter[2] \"$sc_filter[3]\" ]]"
  return $?
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
