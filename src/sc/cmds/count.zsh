#count input objects
cmd_count_() {
  need_pipe_

  jq_ slurp s '. | length' -
}
