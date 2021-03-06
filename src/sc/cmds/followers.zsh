#get followers of input users
cb_user_() {
  need_pipe_
  typeset -A user=($@)

  get_ "users/$user[id]/followers" limit 200
  typeset data="$returned"
  extract_collection_ "$data"
  split_ 'users' "$data"

  output_ "$data" 'users'
}

cmd_followers_() {
  if [[ ! $sc_pipe ]]; then
    $sc_exec resolve $sc_trailing | sc users | sc followers
    return
  fi

  eval_loop_ user cb_user_
}
