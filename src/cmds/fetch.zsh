#download input tracks
cb_track_() {
  typeset -A track=($@)

  typeset outd="${mu_dirs[tracks]}/${data[artist]//\//%}"
  typeset outf="${outd}/${data[title]//\//%}.${data[ext]}"

  mkdir -p "$outd"

  build_url_ "${data[stream_url]}"
  typeset url="$returned"

  [[ $mu_tty ]] && echo "fetching $data[artist] - $data[title]"

  wcache_ $progress -l \
    --cache="$mu_dirs[cache]" \
    --best-by="$mu_expiration[tracks]" \
    --output="$outf" \
    "$url" || die_ "failed to get file"

  [[ ! $mu_tty ]] && echo "file://${outf:a}"

  return
}

cmd_fetch_() {
  need_pipe_

  typeset -g progressj=""
  [[ $mu_tty ]] && progress="--bar"

  eval_loop_ track cb_track_
}
