cmd_fetch() {
  if [[ ! $sc_pipe ]]; then
    $sc_exec resolve $sc_trailing | $sc_exec tracks | $sc_exec fetch
  fi

  typeset prog=""
  typeset otty
  if [[ $sc_tty ]]; then
    prog="--bar"
    otty=true
    unset sc_tty
  fi

  jq_ s '. | sc::tfilter("track") | sc::obj_to_zsh' - | while read -r line; do
    eval "typeset -A data=(${line})"
    [[ (-z $data[title] || -z $data[artist] || -z $data[ext] || \
      -z $data[stream_url]) ]] && die_ "invalid track data"

    typeset outd="${sc_dirs[tracks]}/${data[artist]//\//%}"
    typeset outf="${outd}/${data[title]//\//%}.${data[ext]}"
    mkdir -p "$outd"

    build_url_ "${data[stream_url]}"

    [[ $otty ]] && echo "fetching $data[artist] - $data[title]"

    wcache "$prog" -l -c "$sc_dirs[cache]" -b inf -O "$outf" \
      "$returned" || die_ "failed to get file"

    [[ ! $otty ]] && echo "file://${outf:a}"
  done
}
