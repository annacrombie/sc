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

cmd_users_() {
  if [[ ! $sc_pipe ]]; then
    search_ 'users' $sc_trailing
    split_ 'users' $sc_return
    return
  fi

  if [[ $sc_tty ]]; then
    typeset osc_tty="$sc_tty"
    unset sc_tty
  fi

  typeset -ga encountered_users=()

  typeset tmpf=$(mktemp)
  eval_loop_ user cb_user_ track cb_track_ > $tmpf

  typeset -g sc_tty=$osc_tty
  output_ "$tmpf" 'users'
  rm "$tmpf"
}
