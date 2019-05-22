cmd_play_() {
  if [[ ! $sc_pipe ]]; then
    exec mpv "${sc_dirs[tracks]}/${sc_trailing}"
  fi

  mktmp_
  typeset plst="$returned"
  > "$plst"
  exec < /dev/tty
  mpv --playlist="$plst"
}
