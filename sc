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
  mkdir -vp "$dir"
done

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
  [[ -n "$key" ]] && key="--key=${key}"
  [[ $force ]] && force="--best-by=0"

  load_keys_
  build_paramstr_ ${(kv)params}
  params[client_id]="$sc_keys[$sc_keyid]"
  build_paramstr_ ${(kv)params}

  sc_return="$(wcache --cache="./cache" "$force" "$key" --echo-output \
    "${sc_api}/${endpoint}?${sc_return}")"
}

get_track_() {
  get_ "tracks/$1"
}

get_user_() {
  get_ "users/$1"
}

search_() {
  typeset ep="$1"; shift
  typeset query="$@"
  get_ -k "?${query// /+}" "$ep" 'q' "${query// /+}"
}

display_() {
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

users_search_() {
  search_ 'users' $@
  if [[ $sc_tty ]]; then
    display_ $sc_return search/users
  else
    jq -Mr '[.[] | "user_id \(.id)"]|join("\n")' "$sc_return"
  fi
}

tracks_search_() {
  search_ 'tracks' $@
  display_ $sc_return search/tracks
}

tracks_dl_() {
  for track in $@; do
    get_ 'tracks'
  done
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
      (u | users) users_search_ $@;;
      (t | tracks) users_search_ $@;;
    esac;;
  (u | user)
    case $sc_command in
      (i | info) users_info_ $@;;
      *) users_dl_ $@;;
    esac;;
  (t | tracks)
    case $sc_command in
      (s | search) tracks_search_ $@;;
      (dl | download) tracks_dl_ $@;;
    esac;;
esac
