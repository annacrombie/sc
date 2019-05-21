cmd_play_() {
  if [[ ! $sc_pipe ]]; then
    $sc_exec resolve $sc_trailing |\
      $sc_exec tracks |\
      $sc_exec fetch |\
      $sc_exec play
    return
  fi

  mktmp_
  typeset plst="$returned"
  > "$plst"
  exec < /dev/tty
  mpv --playlist="$plst"
}