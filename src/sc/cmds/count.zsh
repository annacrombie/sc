cmd_count_() {
  [[ ! $sc_pipe ]] && die_ "no input"

  jq_ slurp s '. | length' -
}
