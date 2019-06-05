#get a user by id
cmd_user_() {
  typeset id="$sc_trailing[1]"
  [[ -z $id ]] && die_ "please provide a user id"

  get_ "users/$id"
  typeset file=$returned
  output_ "$file" 'tracks'
}
