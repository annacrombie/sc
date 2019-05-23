#describe input objects
cmd_describe_() {
  if [[ ! $sc_pipe ]]; then
    $sc_exec resolve $sc_trailing | $sc_exec describe
    return
  fi

  jq_ s '. | sc::dstream' - dlvl desc
}
