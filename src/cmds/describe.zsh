#describe input objects
cmd_describe_() {
  need_pipe_

  jq_ s '. | mu::dstream' - dlvl desc
}
