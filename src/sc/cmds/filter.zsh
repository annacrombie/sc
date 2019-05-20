cmd_filter_() {
  typeset filter=${sc_trailing[1]}
  typeset tmp=$(mktemp)

  jq_ slurp s "[.[] | select($filter)]" - > $tmp

  output_ "$tmp" mix
  rm "$tmp"
}
