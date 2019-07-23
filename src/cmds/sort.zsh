#sort input objects
cmd_sort_() {
  need_pipe_
  typeset sort_col=${mu_trailing[1]:-id}
  typeset sort_dir=${mu_trailing[2]:-desc}
  mktmp_
  typeset tmp="$returned"

  case $sort_dir in
    desc) sort_dir="reverse";;
    asc) sort_dir=".";;
    *) die_ "invalid sort direction";;
  esac

  jq_ slurp s "[.] | flatten | sort_by(.$sort_col) | $sort_dir" - > $tmp

  output_ "$tmp" mix
}
