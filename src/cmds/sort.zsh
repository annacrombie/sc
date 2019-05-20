cmd_sort_() {
  typeset sort_col=${sc_trailing[1]:-id}
  typeset sort_dir=${sc_trailing[2]:-desc}
  typeset tmp=$(mktemp)

  case $sort_dir in
    desc) sort_dir="reverse";;
    asc) sort_dir=".";;
    *) die_ "invalid sort direction";;
  esac

  jq_ slurp s "[.] | flatten | sort_by(.$sort_col) | $sort_dir" - > $tmp

  output_ "$tmp" mix

  rm "$tmp"
}
