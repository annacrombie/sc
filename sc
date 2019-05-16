#!/bin/zsh

typeset -g sc_path="${0:A:h}"
source "${sc_path}/optparse.zsh"

typeset -g sc_api="https://api.soundcloud.com"
typeset -g sc_keys=()
typeset -g sc_keyfile="keys"
typeset -g sc_keyid=1

typeset -g sc_return

typeset -gA sc_dirs
sc_dirs=(
  base   "./sc_data"
  cache  "./sc_data/cache"
  tracks "./sc_data/tracks"
)

typeset dir
for dir in ${(v)sc_dirs}; do
  mkdir -p "$dir"
done

die_() {
  echo "$@" >&2
  exit 1
}

load_keys_() {
  source "$sc_keyfile"
}

build_paramstr_() {
  typeset -A params=($@)
  typeset key val

  typeset paramlen=${#params}
  typeset i=0

  typeset -g sc_return=""

  for key val in ${(kv)params}; do
    sc_return+="${key}=${val}"
    i=$((i+1))
    [[ $i -lt $paramlen ]] && sc_return+="&"
  done
}

get_api_url_() {
  typeset endpoint="$1"; shift
  typeset -A params=($@)

  load_keys_
  build_paramstr_ ${(kv)params}
  params[client_id]="$sc_keys[$sc_keyid]"
  build_paramstr_ ${(kv)params}

  sc_return="${sc_api}/${endpoint}?${sc_return}"
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

  [[ -n "$key" ]] && key="--key=${key}"
  [[ $force ]] && force="--best-by=0"

  sc_return="$(wcache --cache=$sc_dirs[cache] $force $key --echo-output \
    "${sc_return}")"

  [[ -z "$sc_return" ]] && die_ "failed to get anything"
}

search_() {
  typeset ep="$1"; shift
  typeset query="$@"
  [[ -z $query ]] && die_ "no query given"

  get_ -k "?${query// /+}" "$ep" 'q' "${query// /+}"

  output_ $sc_return search/$ep
}

resolve_() {
  typeset pl="$1"; shift
  typeset d="$sc_dirs[cache]/api.soundcloud.com/"
  typeset f="$d/resolve/${pl}@"
  typeset rsv

  if [[ -L "$f" ]]; then
    sc_return="${${(s:/:)f:A}[-2,-1]}"
    return
  fi

  get_api_url_ 'resolve' 'url' "https://soundcloud.com/$pl"
  rsv="$(wget -qSO- --spider --max-redirect=0 "$sc_return" 2>&1 | \
    grep Location | \
    sed 's/.*Location: https:\/\/api.soundcloud.com\/\(.*\)?.*/\1/g')"

  [[ -z "$rsv" ]] && die_ "failed to resolve $pl :("

  mkdir -p "${f:h}"

  ln -sr "$d/$rsv$" "$f"
  get_ "$rsv"
  typeset -a rsv=(${(s:/:)rsv})
  sc_return="$rsv$"
}

split_() {
  typeset ep=$1
  typeset data=$2
  typeset -A ids=($(jq -Mr '.[] | .id' $data))
  typeset i=0

  for id in $ids; do
    [[ -f "${sc_dirs[cache]}/api.soundcloud.com/$ep/$id$" ]] && continue
    jq -Mc ".[$i]" "$data" > "${sc_dirs[cache]}/api.soundcloud.com/$ep/$id$"
    ((i+=1))
  done
}

output_() {
  typeset data=$1
  if [[ $sc_tty ]]; then
    typeset jq="${sc_path}/jq/disp/$2.jq"
    typeset cols="$(head -n 1 "$jq")"

    jq -Mr -f "$jq" "$data" | column -s '|' -t -N "${cols##\#}"
  else
    typeset jq="${sc_path}/jq/raw/$2.jq"

    jq -Mr -f "$jq" "$data"
  fi
}

typeset -g sc_tty
[[ -t 1 ]] && sc_tty=true

optparse_disp[banner]="Usage: $sc_name <resource> <command> <query>"
optparse_disp[desc]='soundloud client'
typeset -gA opts=()
typeset -gA optalias=()

sc_resource=$1
sc_command=$2
shift 2

case $sc_resource in
  (s | search)
    case $sc_command in
      (users | tracks)
        search_ $sc_command $@
        split_ $sc_command $sc_return;;
      *)
        die_ "invalid search type $sc_command";;
    esac;;
  (u | user)
    case $sc_command in
      (i | info) users_info_ $@;;
      *) users_dl_ $@;;
    esac;;
  (t | tracks)
    cat - | while read line; do
      typeset -a data=(${(s: :)line})
      case $data[1] in
        track_id) echo $line;;
        user_id)
          get_ "users/$data[2]/tracks"
          split_ 'tracks' $sc_return
          output_ $sc_return 'tracks'
          ;;
      esac
    done;;
  (r |resolve)
    resolve_ $sc_command
    typeset -a resolved=(${(s: :)sc_return})
    output_ "$sc_dirs[cache]/api.soundcloud.com/${(j:/:)resolved}" ${resolved[1]%%s}
    ;;
esac
