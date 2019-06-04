#get tracks from input
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

cb_query_(){
  typeset -A q=($@)
  search_ 'tracks' "$q[query]"
  split_ 'tracks' $returned
}

cmd_tracks_() {
  if [[ $sc_tty ]]; then
    typeset osc_tty="$sc_tty"
    unset sc_tty
  fi

  mktmp_
  typeset tmp="$returned"
  eval_loop_ user cb_user_ track cb_track_ query cb_query_ > $tmp

  typeset -g sc_tty=$osc_tty
  output_ "$tmp" 'tracks'
}
