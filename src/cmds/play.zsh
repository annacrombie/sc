#play input files
cmd_play_() {
  if [[ ! $mu_pipe ]]; then
    exec mpv "${mu_dirs[tracks]}/${mu_trailing}"
  fi

  mktmp_
  typeset plst="$returned"
  > "$plst"
  exec < /dev/tty
  mpv --playlist="$plst"
}
