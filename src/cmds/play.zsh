cmd_play_() {
  if [[ $sc_pipe ]]; then
    typeset plst=$(mktemp)
    cat - > "$plst"
    exec </dev/tty
    mpv --playlist="$plst"
  else
    $sc_exec resolve $sc_trailing |\
      $sc_exec tracks |\
      $sc_exec fetch |\
      $sc_exec play
  fi
}
