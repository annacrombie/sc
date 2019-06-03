#display a track's art

cb_track_() {
  typeset -A track=($@)
  typeset ret

  [[ -z $track[img] ]] && return

  wcache_ --best-by=$sc_expiration[cache] --cache=$sc_dirs[cache] \
    $key --link-output -O "$tmpdir/${track[artist]} - ${track[title]}" "${track[img]}"
}

cmd_art_() {
  if [[ ! $sc_pipe ]]; then
    die_ "no data"
  fi

  mktmp_ -d
  typeset -g tmpdir="$returned"

  eval_loop_ track cb_track_

  feh -. "$tmpdir"
}
