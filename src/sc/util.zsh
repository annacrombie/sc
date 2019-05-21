return_() {
  typeset -g returned="$@"
}

log_() {
  echo "[sc log] $@"
}

log_debug_() {
  [[ $sc_verbosity -gt 1 ]] && log_ "[debug] $@" >&2
}

log_err_() {
  log_ "[error] $@" >&2
}

die_() {
  log_err_ "$@"
  cleanup_
  exit 1
}

cleanup_() {
  for dir in $sc_tmpfiles; do
    [[ -f $dir ]] && rm "$dir"
  done
}

initialize_dirs_() {
  typeset dir

  for dir in $@; do
    mkdir -p "$dir"
  done
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

  mktmp_
  typeset f="$returned"

  jq -Mc ".collection" "$data" > "$f"
  mv "$f" "$data"
}

to_json_() {
  typeset -A obj=($@)
  typeset tmp k v
  typeset -a out=()
  for k v in ${(kv)obj}; do
    k=${k//\"/\\\"}
    if [[ $v = <-> ]]; then
      printf -v tmp '"%s":%s' $k $v
    else
      printf -v tmp '"%s":"%s"' $k ${v//\"/\\\"}
    fi

    out+="$tmp"
  done

  echo "{${(j:,:)out}}"
}

mktmp_() {
  typeset tmpf=$(mktemp --tmpdir=/tmp sctmp_XXXXXXXX)
  sc_tmpfiles+="$tmpf"

  return_ "$tmpf"
}
