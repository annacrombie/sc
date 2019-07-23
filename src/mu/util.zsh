output_() {
  typeset data=$1
  typeset args=("$data" limit $mu_opt[take])

  if [[ $mu_tty ]]; then
    typeset f="disp/$2.jq"
    typeset jq="${mu_dirs[jq]}"

    # TODO don't do this anymore
    typeset cols="$(head -n 1 "$jq/$f")"
    cols="${cols##\#}"

    jq_ r slurp "$f" $args |
      if [[ -n $cols ]]; then
        column -s '|' -t
      else
        cat -
      fi
  else
    typeset f="raw/desc/$2.jq"
    jq_ c "$f" $args
  fi
}

eval_loop_() {
  need_pipe_

  typeset -A callbacks=($@)

  jq_ r s '. | mu::zstream' -  | while read -r line; do
    eval "typeset -A data=(${line})"
    typeset cb=$callbacks[$data[type]]
    [[ -z $cb ]] && die_ "invalid datatype $data[type]"

    $cb ${(kv)data}
  done
}

need_pipe_() {
  [[ ! $mu_pipe ]] && die_ "no data"
}

cleanup_() {
  for dir in $mu_tmpfiles; do
    if [[ -f $dir ]]; then
      rm "$dir"
    elif [[ -d $dir ]]; then
      rm -r "$dir"
    fi
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

  mkdir -p "${mu_dirs[api]}/$ep"

  for id in $ids; do
    typeset file="${mu_dirs[api]}/$ep/$id$"
    [[ -f $file ]] && is_fresh_ "$file" "$mu_expiration[cache]" && continue

    jq -Mc ".[$i]" "$data" > "$file"
    ((i+=1))
  done
}

extract_collection_() {
  typeset data="$1"

  is_coll=$(jq -Mrf "${mu_dirs[jq]}/is_collection.jq" "$data")
  [[ $is_coll = false ]] && return

  mktmp_
  typeset f="$returned"

  jq_ c s ".collection" "$data" > "$f"
  mv "$f" "$data"
}
