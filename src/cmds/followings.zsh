cb_user_() {
  typeset -A user=($@)

  get_ "users/$user[id]/followings"
  extract_collection_ $returned
  split_ 'users' $returned

  output_ $returned 'users'
}

cmd_followings_() {
  if [[ ! $sc_pipe ]]; then
    $sc_exec resolve $sc_trailing | sc users | sc followings
    return
  fi

  eval_loop_ user cb_user_
}
