#get followings of input users
cb_user_() {
  typeset -A user=($@)

  get_ "users/$user[id]/followings" limit 200
  typeset data="$returned"

  extract_collection_ "$data"
  split_ 'users' "$data"
  output_ "$data" 'users'
}

cmd_followings_() {
  if [[ ! $sc_pipe ]]; then
    $sc_exec resolve $sc_trailing | sc users | sc followings
    return
  fi

  eval_loop_ user cb_user_
}
