cb_track_() {
  typeset -A track=($@)

  to_json_ ${(kv)track}
}

cb_user_() {
  typeset -A user=($@)

  get_ "users/$user[id]/tracks" order created_at limit 100
  typeset file=$returned

  split_ 'tracks' "$file"
  output_ "$file" 'tracks'
}

cmd_tracks_() {
  if [[ ! $sc_pipe ]]; then
    search_ 'tracks' $sc_trailing
    split_ 'tracks' $returned
    return
  fi

  if [[ $sc_tty ]]; then
    typeset osc_tty="$sc_tty"
    unset sc_tty
  fi

  typeset tmpf=$(mktemp)
  eval_loop_ user cb_user_ track cb_track_ > $tmpf

  typeset -g sc_tty=$osc_tty
  output_ "$tmpf" 'tracks'
  rm "$tmpf"
}
