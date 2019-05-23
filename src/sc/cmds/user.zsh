#get a user by id
cmd_user_() {
  [[ -z "$sc_trailing[1]" ]] && die_ "please provide a user id"
  get_ "users/$sc_trailing[1]"
  typeset file=$returned
  output_ "$file" 'tracks'
}
