#get users from input
cb_track_() {
  typeset -A track=($@)

  if (($encountered_users[(Ie)$track[user_id]])); then
    return
  fi

  encountered_users+=$track[user_id]

  get_ "users/$track[user_id]"
  typeset file=$returned

  output_ "$file" 'user'
}

cb_user_() {
  typeset -A user=($@)

  to_json_ ${(kv)user}
}

cb_query_(){
  typeset -A q=($@)
  search_ 'users' "$q[query]"
  split_ 'users' $returned
}

cmd_users_() {
  if [[ $sc_tty ]]; then
    typeset osc_tty="$sc_tty"
    unset sc_tty
  fi

  typeset -ga encountered_users=()

  mktmp_
  typeset tmp="$returned"

  eval_loop_ user cb_user_ track cb_track_ query cb_query_ > $tmp

  typeset -g sc_tty=$osc_tty
  output_ "$tmp" 'users'
}
