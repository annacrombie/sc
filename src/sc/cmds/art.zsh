#display an object's art with feh

cb_track_() {
  typeset -A track=($@)
  fetch_art_ "${track[img]}" "${track[artist]} - ${track[title]}"
}

cb_user_() {
  typeset -A user=($@)
  fetch_art_ "${user[img]}" "${user[username]}"
}

fetch_art_() {
  typeset url="$1"
  typeset title="$2"
  typeset ret

  [[ -z $url ]] && return

  wcache_ --best-by=$sc_expiration[cache] --cache=$sc_dirs[cache] \
    --link-output -O "$tmpdir/$title" "$url"
}

cmd_art_() {
  if [[ ! $sc_pipe ]]; then
    die_ "no data"
  fi

  mktmp_ -d
  typeset -g tmpdir="$returned"

  eval_loop_ track cb_track_ user cb_user_

  feh -. "$tmpdir"
}
