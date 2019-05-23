cmd_track_() {
  [[ -z "$sc_trailing[1]" ]] && die_ "please provide a track id"
  get_ "tracks/$sc_trailing[1]"
  typeset file=$returned
  output_ "$file" 'tracks'
}
