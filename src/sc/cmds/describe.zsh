#describe input objects
cmd_describe_() {
  need_pipe_

  jq_ s '. | sc::dstream' - dlvl desc
}
