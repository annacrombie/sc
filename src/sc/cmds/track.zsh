#get a track by id

cmd_track_() {
  typeset id="$sc_trailing[1]"
  [[ -z "$id" ]] && die_ "please provide a track id"

  get_ "tracks/$id"
  typeset file=$returned
  output_ "$file" 'tracks'
}
