#get followings of input users
cb_user_() {
  need_pipe_
  typeset -A user=($@)

  get_ "users/$user[id]/followings" limit 200
  typeset data="$returned"

  extract_collection_ "$data"
  split_ 'users' "$data"
  output_ "$data" 'users'
}

cmd_followings_() {
  if [[ ! $mu_pipe ]]; then
    $mu_exec resolve $mu_trailing | mu users | mu followings
    return
  fi

  eval_loop_ user cb_user_
}