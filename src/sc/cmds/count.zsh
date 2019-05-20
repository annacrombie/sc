cmd_count_() {
  [[ ! $sc_pipe ]] && die_ "no input"

  wc -l
}
