#!/bin/zsh

typeset -g sc_exec="${0:A}"
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

build_url_() {
  typeset base="$1"; shift
  typeset -A params=($@)

  load_keys_
  params[client_id]="$sc_keys[$sc_keyid]"
  build_paramstr_ ${(kv)params}

  build_paramstr_ ${(kv)params}
  sc_return="${base}?${sc_return}"
}

get_api_url_() {
  typeset endpoint="$1"; shift
  typeset -A params=($@)

  build_url_ "${sc_api}/${endpoint}" ${(kv)params}
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

  output_ $sc_return $ep
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


jq_() {
 typeset jq="$1"
 typeset data="$2"
 typeset lim=${optparse_result[take]}

 jq -Mr --arg limit "$lim" -f "$jq" "$data"
}

output_() {
  typeset data=$1
  if [[ $sc_tty ]]; then
    typeset jq="${sc_path}/jq/disp/$2.jq"
    typeset cols="$(head -n 1 "$jq")"

    jq_ "$jq" "$data" |
      if [[ -n "${cols##\#}" ]]; then
        column -s '|' -t -N "${cols##\#}"
      else
        cat -
      fi
  else
    typeset jq="${sc_path}/jq/raw/$2.jq"

    jq_ "$jq" "$data"
  fi
}

typeset -g sc_tty
[[ -t 1 ]] && sc_tty=true
typeset -g sc_pipe
[[ -t 0 ]] || sc_pipe=true

optparse_disp[banner]="Usage: sc [OPTIONS] COMMAND [QUERY]"
optparse_disp[desc]="A lightweight soundcloud client, conforming to unix \
philosophy."
optparse_disp[info]='
COMMANDS
  d, describe   - describe input object(s), or re-run after resolve Q
  f, fetch    Q - download input object(s), or re-run after resolve Q | tracks
  t, tracks   Q - get tracks from input, or query Q
  u, users    Q - get users from input, or query Q
  p, play       - play input files with mpv(1)
  r, resolve  Q - resolve Q to an object
  l, library    - display downloaded tracks

OBJECTS
  Many sc commands take input as objects and/or output objects.  An object is
  either a track, user, or playlist.  This allows sc commands to be chained
  like so:

    sc resolve <artist> | sc --take=5 tracks  | sc fetch | sc play

  This will resolve the input string to an artist id, get a list of their tracks
  (outputting only 5), fetch those tracks, and finally play the result.

CACHE
  sc internally uses wcache(1) which is a thin wrapper around wget(1) that
  caches downloads for relatively long periods of time.  For this reason,
  repeated sc querys will not touch the network.

  If I first run (getting the first track for an artist)

    sc -t 1 users tennyson | sc -t 1 tracks | sc describe

  And then run

    sc -t 1 users tennyson | sc -t 1 tracks | sc fetch

  Only the final pipe touches the network, since all necessarry metadata has
  already been fetched.'
typeset -gA opts=(take= "set the limit on results")
typeset -gA optalias=(t take=)

optparse_parse_ opts optalias $@

[[ $optparse_result[take] ]] && \
  typeset -a sc_exec=($sc_exec --take=$optparse_result[take])

typeset sc_resource=$optparse_trailing[1]
typeset -a sc_trailing=(${optparse_trailing[2,-1]})

case $sc_resource in
  (f | fetch)
    if [[ $sc_pipe ]]; then
      typeset prog=""
      typeset otty
      if [[ $sc_tty ]]; then
        prog="--bar"
        otty=true
        unset sc_tty
      fi

      cat - | while read line; do
        typeset -a data=(${(s: :)line})
        case $data[1] in
          track_id)
            get_ "tracks/$data[2]"
            eval "typeset -A td=($(output_ "$sc_return" "desc/track"))"
            typeset outd="${sc_dirs[tracks]}/${td[artist]//\//%}"
            typeset outf="${outd}/${td[title]//\//%}.${td[ext]}"
            mkdir -p "$outd"
            build_url_ "${td[stream_url]}"
            [[ $otty ]] && echo "fetching $td[artist] - $td[title]"
            wcache "$prog" -l -c "$sc_dirs[cache]" -b inf -O "$outf" \
              "$sc_return" || die_ "failed to get file"

            [[ ! $otty ]] && echo "file://${outf:a}"
            ;;
        esac
      done
    else
      $sc_exec resolve $sc_trailing | $sc_exec tracks | $sc_exec fetch
    fi;;
  (d | describe)
    if [[ $sc_pipe ]]; then
      cat - | while read line; do
        typeset -a data=(${(s: :)line})
        case $data[1] in
          user_id)
            get_ "users/$data[2]"
            [[ $sc_tty ]] && echo "user"
            output_ "$sc_return" "desc/user"
            ;;
          track_id)
            get_ "tracks/$data[2]"
            [[ $sc_tty ]] && echo "track"
            output_ "$sc_return" "desc/track"
            ;;
        esac
      done
    else
      $sc_exec resolve $sc_trailing | $sc_exec describe
    fi;;
  (u | users)
    if [[ $sc_pipe ]]; then
      cat - | while read line; do
        typeset -a data=(${(s: :)line})
        case $data[1] in
          user_id) echo "$line";;
        esac
      done
    else
      search_ 'users' $sc_trailing
      split_ 'users' $sc_return
    fi;;
  (t | tracks)
    if [[ $sc_pipe ]]; then
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
      done
    else
      search_ 'tracks' $sc_trailing
      split_ 'tracks' $sc_return
    fi;;
  (r | resolve)
    resolve_ $sc_trailing
    typeset -a resolved=(${(s: :)sc_return})
    output_ "$sc_dirs[cache]/api.soundcloud.com/${(j:/:)resolved}" \
      ${resolved[1]%%s}
    ;;
  (l | library)
    tree -C "$sc_dirs[tracks]"
    ;;
  (p | play)
    if [[ $sc_pipe ]]; then
      typeset plst=$(mktemp)
      cat - > "$plst"
      exec </dev/tty
      mpv --playlist="$plst"
    else
      $sc_exec resolve $sc_trailing |\
        $sc_exec tracks |\
        $sc_exec fetch |\
        $sc_exec play
    fi
    ;;
  *)
    $sc_exec fetch $sc_resource $sc_trailing
    ;;
esac
